import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bp_monitor_iot/core/constants/app_strings.dart';
import 'package:bp_monitor_iot/core/theme/app_colors.dart';
import 'package:bp_monitor_iot/core/theme/app_theme.dart';
import 'package:bp_monitor_iot/features/history/model/patient_model.dart';

import '../../../analysis/analysis_screen.dart';

class PatientDetailsDialog extends StatelessWidget {
  final PatientModel patient;

  const PatientDetailsDialog({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('MMM dd, yyyy').format(patient.timestamp);
    final timeStr = DateFormat('HH:mm').format(patient.timestamp);

    return AlertDialog(
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(AppStrings.recordDetails),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patient Header
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.ecgGreen.withValues(alpha: 0.1),
                  child: Icon(
                    patient.gender == AppStrings.genderMale
                        ? Icons.male
                        : Icons.female,
                    color: AppColors.ecgGreen,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        patient.name,
                        style: AppTheme.textTheme.headlineSmall?.copyWith(
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        '${patient.gender} • ${patient.age} ${AppStrings.years}',
                        style: AppTheme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Timestamp
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  '$dateStr at $timeStr',
                  style: AppTheme.textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Metrics Grid
            _buildMetricRow(
              context,
              icon: Icons.speed,
              label: AppStrings.bloodPressure,
              value:
                  '${patient.bloodPressure.systolic.toInt()}/${patient.bloodPressure.diastolic.toInt()}',
              unit: AppStrings.unitMmHg,
              color: AppColors.bpAmber,
            ),
            const SizedBox(height: 16),
            _buildMetricRow(
              context,
              icon: Icons.favorite,
              label: AppStrings.heartRate,
              value: '${patient.oximeter.heartRate}',
              unit: AppStrings.unitBpm,
              color: AppColors.heartRateRed,
            ),
            const SizedBox(height: 16),
            _buildMetricRow(
              context,
              icon: Icons.water_drop,
              label: AppStrings.spo2,
              value: '${patient.oximeter.spo2}',
              unit: AppStrings.unitPercentage,
              color: AppColors.spo2Cyan,
            ),

            const SizedBox(height: 32),

            // Analysis Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AnalysisScreen(patient: patient),
                    ),
                  );
                },
                icon: const Icon(Icons.analytics_outlined),
                label: const Text(AppStrings.analysis),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.ecgGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required String unit,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTheme.textTheme.labelSmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      value,
                      style: AppTheme.textTheme.titleLarge?.copyWith(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      unit,
                      style: AppTheme.textTheme.labelSmall?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
