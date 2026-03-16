import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../history/model/patient_model.dart';
import 'cubit/analysis_cubit.dart';
import 'cubit/analysis_state.dart';
import 'model/analysis_model.dart';
import 'widgets/analysis_header.dart';
import 'widgets/analysis_card.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_strings.dart';

class AnalysisScreen extends StatelessWidget {
  final PatientModel patient;

  const AnalysisScreen({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AnalysisCubit()..analyzePatient(patient),
      child: Scaffold(
        backgroundColor: AppColors.lightScaffoldBackground,
        appBar: AppBar(
          title: const Text(AppStrings.analysis),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: AppColors.lightTextPrimary,
        ),
        body: BlocBuilder<AnalysisCubit, AnalysisState>(
          builder: (context, state) {
            return switch (state) {
              AnalysisLoading() => const Center(
                  child: CircularProgressIndicator(color: AppColors.ecgGreen),
                ),
              AnalysisError(message: final msg) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(msg),
                    ],
                  ),
                ),
              AnalysisLoaded(result: final result) => _buildBody(context, result),
              _ => const SizedBox.shrink(),
            };
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, AnalysisResult result) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnalysisHeader(patient: patient),
          const SizedBox(height: 32),

          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 20),
            child: Text(
              'HEALTH ANALYSIS',
              style: AppTheme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
                color: AppColors.lightTextSecondary.withValues(alpha: 0.7),
              ),
            ),
          ),

          AnalysisCard(
            title: AppStrings.bloodPressure,
            value:
                '${patient.bloodPressure.systolic.toInt()}/${patient.bloodPressure.diastolic.toInt()}',
            unit: AppStrings.unitMmHg,
            interpretation: result.bp,
            icon: Icons.speed,
          ),
          const SizedBox(height: 20),

          AnalysisCard(
            title: AppStrings.heartRate,
            value: '${patient.oximeter.heartRate}',
            unit: AppStrings.unitBpm,
            interpretation: result.hr,
            icon: Icons.favorite,
          ),
          const SizedBox(height: 20),

          AnalysisCard(
            title: AppStrings.spo2,
            value: '${patient.oximeter.spo2}',
            unit: AppStrings.unitPercentage,
            interpretation: result.spo2,
            icon: Icons.water_drop,
          ),

          const SizedBox(height: 40),

          // Disclaimer
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.blue.withValues(alpha: 0.1)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.info_outline,
                    color: Colors.blue,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Professional medical advice should be sought for any health concerns. This analysis is automated based on available data.',
                    style: AppTheme.textTheme.bodyMedium?.copyWith(
                      color: Colors.blueGrey.shade600,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
