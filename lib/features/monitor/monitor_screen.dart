import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/monitor_cubit.dart';
import 'cubit/monitor_state.dart';
import 'repository/monitor_repository.dart';
import '../../core/constants/app_strings.dart';
import '../../core/data_source/firebase/firestore_data_source.dart';
import '../../core/utils/snackbars/app_snackbars.dart';
import '../../core/utils/dialogs/patient_info_dialog.dart';
import 'widgets/ecg_chart_card_widget.dart';
import 'widgets/monitor_controls_widget.dart';
import 'widgets/monitor_screen_selectors.dart';
import 'widgets/saving_overlay_widget.dart';
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
    return BlocListener<MonitorCubit, MonitorState>(
      listenWhen: (_, current) => current is MonitorSaveResult,
      listener: (context, state) {
        if (state is MonitorSaveResult) {
          if (state.success) {
            AppSnackbars.showSuccess(
              context,
              AppStrings.measurementSavedSuccess,
            );
          } else {
            AppSnackbars.showError(
              context,
              '${AppStrings.measurementSavedFailure}${state.error ?? 'Unknown error'}',
            );
          }
        }
      },
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // ── Vitals region ─────────────────────────────────────────
                BlocSelector<MonitorCubit, MonitorState, VitalsSnapshot>(
                  selector: (state) {
                    if (state is MonitorConnected) {
                      return VitalsSnapshot(
                        hr: state.currentVitals.oximeter.heartRate,
                        spo2: state.currentVitals.oximeter.spo2,
                        sys: state.currentVitals.bloodPressure.systolic,
                        dia: state.currentVitals.bloodPressure.diastolic,
                        livePressure: state.currentVitals.livePressure,
                      );
                    }
                    return const VitalsSnapshot.empty();
                  },
                  builder: (context, snapshot) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      VitalsRowWidget(
                        livePressure: snapshot.livePressure,
                        sys: snapshot.sys,
                        dia: snapshot.dia,
                        hr: snapshot.hr,
                        spo2: snapshot.spo2,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ── ECG chart ─────────────────────────────────────────────
                Expanded(
                  child: BlocSelector<MonitorCubit, MonitorState, EcgSnapshot>(
                    selector: (state) {
                      if (state is MonitorConnected) {
                        return EcgSnapshot(
                          isConnected: true,
                          ecgData: state.currentVitals.ecg,
                        );
                      }
                      return const EcgSnapshot(isConnected: false, ecgData: []);
                    },
                    builder: (context, snapshot) => EcgChartCardWidget(
                      isConnected: snapshot.isConnected,
                      ecgData: snapshot.ecgData,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // ── Controls ──────────────────────────────────────────────
                BlocSelector<MonitorCubit, MonitorState, ControlsSnapshot>(
                  selector: (state) {
                    if (state is MonitorConnected) {
                      return ControlsSnapshot(
                        isConnected: true,
                        isMeasuring: state.isMeasuring,
                        isSaving: state is MonitorSaving,
                      );
                    }
                    return const ControlsSnapshot(
                      isConnected: false,
                      isMeasuring: false,
                      isSaving: false,
                    );
                  },
                  builder: (context, snapshot) => MonitorControlsWidget(
                    isConnected: snapshot.isConnected,
                    isMeasuring: snapshot.isMeasuring,
                    isSaving: snapshot.isSaving,
                    onStart: () =>
                        context.read<MonitorCubit>().startMeasurement(),
                    onStop: () =>
                        context.read<MonitorCubit>().stopMeasurement(),
                    onSave: () async {
                      final result = await showDialog<Map<String, dynamic>>(
                        context: context,
                        builder: (context) => const PatientInfoDialog(),
                      );
                      if (result != null && context.mounted) {
                        context.read<MonitorCubit>().saveVitals(
                          name: result['name'] as String,
                          gender: result['gender'] as String,
                          age: result['age'] as int,
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),

          // ── Saving overlay ────────────────────────────────────────────
          BlocBuilder<MonitorCubit, MonitorState>(
            buildWhen: (prev, curr) =>
                (prev is MonitorSaving) != (curr is MonitorSaving),
            builder: (context, state) {
              if (state is! MonitorSaving) return const SizedBox.shrink();
              return const SavingOverlayWidget();
            },
          ),
        ],
      ),
    );
  }
}
