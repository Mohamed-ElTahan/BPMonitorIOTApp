import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_theme.dart';
import 'bp_chart.dart';

class BpChartCardWidget extends StatelessWidget {
  final bool isConnected;
  final List<double> livePressureData;

  const BpChartCardWidget({
    super.key,
    required this.isConnected,
    required this.livePressureData,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
              child: Builder(
                builder: (context) {
                  if (isConnected) {
                    return BpChart(dataPoints: livePressureData);
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
