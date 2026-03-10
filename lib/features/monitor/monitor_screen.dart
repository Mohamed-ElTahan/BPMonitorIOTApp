import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/monitor_cubit.dart';
import 'cubit/monitor_state.dart';
import 'repository/monitor_repository.dart';
import '../../core/data_source/firebase/firestore_data_source.dart';
import '../../core/widgets/snackbars/app_snackbars.dart';
import '../../core/widgets/dialogs/patient_info_dialog.dart';
import 'widgets/ecg_chart_card_widget.dart';
import 'widgets/monitor_controls_widget.dart';
import 'widgets/vitals_row_widget.dart';

class MonitorScreen extends StatelessWidget {
  const MonitorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MonitorCubit(
        context.read<MonitorRepository>(),
        context.read<FirestoreDataSource>(),
      )..initialize(),
      child: const _MonitorScreen(),
    );
  }
}

class _MonitorScreen extends StatelessWidget {
  const _MonitorScreen();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: BlocBuilder<MonitorCubit, MonitorState>(
        builder: (context, state) {
          final isConnected = state is MonitorConnected;

          int hr = 0;
          int spo2 = 0;
          double sys = 0;
          double dia = 0;
          List<double> livePressure = [];
          List<double> ecg = [];

          if (isConnected) {
            hr = state.currentVitals.oximeter.heartRate;
            spo2 = state.currentVitals.oximeter.spo2;
            sys = state.currentVitals.bloodPressure.systolic;
            dia = state.currentVitals.bloodPressure.diastolic;
            livePressure = state.currentVitals.livePressure;
            ecg = state.currentVitals.ecg;
          }

          return Scaffold(
            body: Column(
              children: [
                VitalsRowWidget(
                  livePressure: livePressure,
                  sys: sys,
                  dia: dia,
                  hr: hr,
                  spo2: spo2,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: EcgChartCardWidget(
                    isConnected: isConnected,
                    ecgData: ecg,
                  ),
                ),
                const SizedBox(height: 8),
                MonitorControlsWidget(
                  isConnected: isConnected,
                  onStart: () =>
                      context.read<MonitorCubit>().startMeasurement(),
                  onSave: () async {
                    final result = await showDialog<Map<String, dynamic>>(
                      context: context,
                      builder: (context) => const PatientInfoDialog(),
                    );

                    if (result != null && context.mounted) {
                      await context.read<MonitorCubit>().saveVitals(
                        name: result['name'] as String,
                        sex: result['sex'] as String,
                        age: result['age'] as int,
                      );
                      if (context.mounted) {
                        AppSnackbars.showSuccess(
                          context,
                          'Measurement saved to history',
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
