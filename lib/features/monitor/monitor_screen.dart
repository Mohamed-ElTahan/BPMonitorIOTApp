import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/monitor_cubit.dart';
import 'cubit/monitor_state.dart';
import 'repository/monitor_repository.dart';
import 'widgets/device_status_widget.dart';
import 'widgets/ecg_chart_card_widget.dart';
import 'widgets/float_action_button_widget.dart';
import 'widgets/monitor_controls_widget.dart';
import 'widgets/vitals_row_widget.dart';

class MonitorScreen extends StatelessWidget {
  const MonitorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MonitorCubit(context.read<MonitorRepository>())..initialize(),
      child: const _MonitorScreen(),
    );
  }
}

class _MonitorScreen extends StatelessWidget {
  const _MonitorScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<MonitorCubit, MonitorState>(
          builder: (context, state) {
            final isConnected = state is MonitorConnected;
            final isOnline = isConnected
                ? state.currentVitals.deviceOnline
                : false;

            double hr = 0;
            int spo2 = 0;
            double sys = 0;
            double dia = 0;
            List<double> livePressure = [];
            DateTime? lastDataReceived;
            List<double> ecgHistory = [];

            if (isConnected) {
              hr = state.currentVitals.oximeter.heartRate.toDouble();
              spo2 = state.currentVitals.oximeter.spo2;
              sys = state.currentVitals.bP.systolic;
              dia = state.currentVitals.bP.diastolic;
              livePressure = state.currentVitals.livePressure;

              ecgHistory = state.currentVitals.ecgHistory;
            }

            return Column(
              children: [
                DeviceStatusWidget(isOnline: isOnline),
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
                    lastDataReceived: lastDataReceived,
                    ecgHistory: ecgHistory,
                  ),
                ),
                const SizedBox(height: 24),
                MonitorControlsWidget(
                  isConnected: isConnected,
                  onStart: () =>
                      context.read<MonitorCubit>().startMeasurement(),
                  onStop: () => context.read<MonitorCubit>().stopMeasurement(),
                ),
                const SizedBox(height: 16),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatActionButtonWidget(
        onTap: () => context.read<MonitorCubit>().initialize(),
      ),
    );
  }
}
