import 'package:flutter/material.dart';
import 'package:bp_monitor_iot/core/constants/app_strings.dart';
import 'package:bp_monitor_iot/core/theme/app_colors.dart';
import 'package:bp_monitor_iot/core/theme/app_theme.dart';
import 'package:bp_monitor_iot/features/history/model/patient_model.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final PatientModel patient;
  final VoidCallback onDelete;

  const DeleteConfirmationDialog({
    super.key,
    required this.patient,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.warning_amber_rounded,
              color: Colors.red.shade600,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          const Text(AppStrings.confirmDeleteTitle),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.confirmDeleteContent,
            style: AppTheme.textTheme.bodyMedium?.copyWith(
              color: AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.lightScaffoldBackground,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.lightCardBorder),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.ecgGreen.withValues(alpha: 0.1),
                  child: Icon(
                    patient.gender == AppStrings.genderMale
                        ? Icons.male
                        : Icons.female,
                    color: AppColors.ecgGreen,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        patient.name,
                        style: AppTheme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${patient.gender} • ${patient.age} ${AppStrings.years}',
                        style: AppTheme.textTheme.labelMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            AppStrings.cancel,
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            onDelete();
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade600,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            elevation: 0,
          ),
          child: const Text(AppStrings.delete),
        ),
      ],

      actionsAlignment: MainAxisAlignment.center,
    );
  }
}
