import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import 'ecg_chart.dart';

class EcgChartCardWidget extends StatelessWidget {
  final bool isConnected;
  final List<double> ecgData;

  const EcgChartCardWidget({
    super.key,
    required this.isConnected,
    required this.ecgData,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              AppStrings.ecgWaveform,
              style: AppTheme.textTheme.titleMedium?.copyWith(
                color: AppColors.ecgGreen,
              ),
            ),

            const SizedBox(height: 16),
            Expanded(
              child: Builder(
                builder: (context) {
                  if (isConnected) {
                    return EcgChart(dataPoints: ecgData);
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
