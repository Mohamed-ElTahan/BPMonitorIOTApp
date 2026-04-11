import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_theme.dart';
import '../cubit/monitor_cubit.dart';
import '../cubit/monitor_state.dart';
import 'ecg_chart.dart';

class EcgChartCardWidget extends StatelessWidget {
  const EcgChartCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<MonitorCubit, MonitorState>(
                buildWhen: (prev, curr) {
                  if (prev is MonitorConnected && curr is MonitorConnected) {
                    // Optimized content comparison
                    return !listEquals(
                      prev.currentVitals.ecg,
                      curr.currentVitals.ecg,
                    );
                  }
                  return prev.runtimeType != curr.runtimeType;
                },
                builder: (context, state) {
                  if (state is MonitorConnected) {
                    debugPrint('🎨 REBUILDING ECG CHART');
                    return EcgChart(dataPoints: state.currentVitals.ecg);
                  }
                  return Center(
                    child: Text(
                      AppStrings.waitingForSignal,
                      style: AppTheme.textTheme.bodyMedium,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
