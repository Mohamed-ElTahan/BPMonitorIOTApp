import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_theme.dart';
import '../cubit/monitor_cubit.dart';
import '../cubit/monitor_state.dart';
import 'bp_chart.dart';

class BpChartCardWidget extends StatelessWidget {
  const BpChartCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<MonitorCubit, MonitorState>(
                buildWhen: (prev, curr) {
                  if (prev is MonitorConnected && curr is MonitorConnected) {
                    // Optimized content comparison
                    return !listEquals(
                      prev.currentVitals.livePressure,
                      curr.currentVitals.livePressure,
                    );
                  }
                  return prev.runtimeType != curr.runtimeType;
                },
                builder: (context, state) {
                  if (state is MonitorConnected) {
                    debugPrint('🎨 REBUILDING BP CHART');
                    return BpChart(
                      dataPoints: state.currentVitals.livePressure,
                    );
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
