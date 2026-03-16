import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_strings.dart';
import '../../history/model/patient_model.dart';

class AnalysisHeader extends StatelessWidget {
  final PatientModel patient;

  const AnalysisHeader({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            AppColors.ecgGreen.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: AppColors.ecgGreen.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.ecgGreen.withValues(alpha: 0.2),
                width: 2,
              ),
            ),
            child: CircleAvatar(
              radius: 32,
              backgroundColor: AppColors.ecgGreen,
              child: Icon(
                patient.gender == AppStrings.genderMale ? Icons.male : Icons.female,
                color: Colors.white,
                size: 36,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  patient.name,
                  style: AppTheme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.lightTextPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.lightScaffoldBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${patient.gender} • ${patient.age} ${AppStrings.years}',
                        style: AppTheme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.lightTextSecondary,
                          fontWeight: FontWeight.w600,
                        ),
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
