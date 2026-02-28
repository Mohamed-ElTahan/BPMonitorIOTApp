import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'cubit/monitor_cubit.dart';
import 'cubit/monitor_state.dart';
import 'widgets/ecg_chart.dart';
import 'widgets/vitals_row_widget.dart';

class MonitorScreen extends StatelessWidget {
  const MonitorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Top Row: Vitals Cards
            const VitalsRowWidget(),
            const SizedBox(height: 24),
            // Middle: ECG Chart
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "ECG Waveform",
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          BlocBuilder<MonitorCubit, MonitorState>(
                            builder: (context, state) {
                              if (state is MonitorConnected &&
                                  state.lastDataReceived != null) {
                                String timeStr = DateFormat(
                                  'HH:mm:ss',
                                ).format(state.lastDataReceived!);
                                return Text(
                                  "Last update: $timeStr",
                                  style: theme.textTheme.labelSmall,
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: BlocBuilder<MonitorCubit, MonitorState>(
                          builder: (context, state) {
                            if (state is MonitorConnected) {
                              return EcgChart(dataPoints: state.ecgHistory);
                            }
                            return Center(
                              child: Text(
                                "Waiting for signal...",
                                style: theme.textTheme.bodyMedium,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Bottom: Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<MonitorCubit>().startMeasurement();
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Start'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.surface,
                  ),
                ),
                const SizedBox(width: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<MonitorCubit>().stopMeasurement();
                  },
                  icon: const Icon(Icons.stop),
                  label: const Text('Stop'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.error,
                    foregroundColor: theme.colorScheme.surface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<MonitorCubit>().connect();
        },
        backgroundColor: theme.cardTheme.color,
        tooltip: 'Reconnect MQTT',
        child: Icon(Icons.refresh, color: theme.colorScheme.primary),
      ),
    );
  }
}
