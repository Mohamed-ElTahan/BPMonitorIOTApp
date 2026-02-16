import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../logic/cubit/monitor_cubit.dart';
import '../../logic/cubit/monitor_state.dart';
import '../widgets/connection_status.dart';
import '../widgets/ecg_chart.dart';
import '../widgets/vitals_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('BP Monitor IoT'),
        actions: const [ConnectionStatus()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Top Row: Vitals Cards
            const _VitalsRow(),
            const SizedBox(height: 24),
            // Bottom: ECG Chart
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  border: Border.all(color: AppColors.cardBorder),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "ECG Waveform (AD8232)",
                      style: TextStyle(
                        color: AppColors.ecgGreen,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: BlocBuilder<MonitorCubit, MonitorState>(
                        builder: (context, state) {
                          if (state is MonitorConnected) {
                            return EcgChart(dataPoints: state.ecgHistory);
                          }
                          return const Center(
                            child: Text(
                              "Waiting for signal...",
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Reconnect trigger for demo/testing
          context.read<MonitorCubit>().connect('ws://192.168.4.1:81');
        },
        backgroundColor: AppColors.cardBorder,
        child: const Icon(Icons.refresh, color: AppColors.textPrimary),
      ),
    );
  }
}

class _VitalsRow extends StatelessWidget {
  const _VitalsRow();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MonitorCubit, MonitorState>(
      builder: (context, state) {
        double hr = 0;
        double spo2 = 0;
        double sys = 0;
        double dia = 0;

        if (state is MonitorConnected) {
          hr = state.currentVitals.heartRate;
          spo2 = state.currentVitals.spo2;
          sys = state.currentVitals.systolicBP;
          dia = state.currentVitals.diastolicBP;
        }

        return Row(
          children: [
            Expanded(
              child: VitalsCard(
                title: "Heart Rate",
                value: "${hr.toStringAsFixed(0)} BPM",
                color: AppColors.heartRateRed,
                icon: Icons.favorite,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: VitalsCard(
                title: "SpO2",
                value: "${spo2.toStringAsFixed(0)}%",
                color: AppColors.spo2Cyan,
                icon: Icons.water_drop,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: VitalsCard(
                title: "Blood Pressure",
                value: "${sys.toStringAsFixed(0)}/${dia.toStringAsFixed(0)}",
                subtitle: "mmHg",
                color: AppColors.bpAmber,
                icon: Icons.speed,
              ),
            ),
          ],
        );
      },
    );
  }
}
