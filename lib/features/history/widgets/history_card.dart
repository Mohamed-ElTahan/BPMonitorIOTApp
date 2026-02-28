import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../monitor/models/vitals_model.dart';

class HistoryCard extends StatelessWidget {
  final VitalsModel vitals;

  const HistoryCard({super.key, required this.vitals});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    String dateStr = DateFormat(
      'MMM dd, yyyy - HH:mm',
    ).format(vitals.timestamp);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(dateStr, style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMetric(
                  context,
                  Icons.favorite,
                  '${vitals.heartRate} BPM',
                  AppColors.heartRateRed,
                ),
                _buildMetric(
                  context,
                  Icons.water_drop,
                  '${vitals.spo2}%',
                  AppColors.spo2Cyan,
                ),
                _buildMetric(
                  context,
                  Icons.speed,
                  '${vitals.systolicBP}/${vitals.diastolicBP} mmHg',
                  AppColors.bpAmber,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetric(
    BuildContext context,
    IconData icon,
    String value,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 4),
        Text(value, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
