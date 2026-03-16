import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bp_monitor_iot/core/theme/app_colors.dart';
import 'package:bp_monitor_iot/core/constants/app_strings.dart';
import 'package:bp_monitor_iot/core/theme/app_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/patient_model.dart';
import '../cubit/history_cubit.dart';
import '../../../core/utils/dialogs/delete_confirmation_dialog.dart';
import '../../../core/utils/dialogs/patient_details_dialog.dart';
import '../../analysis/analysis_screen.dart';

class HistoryCard extends StatelessWidget {
  final PatientModel data;
  const HistoryCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    String dateStr = DateFormat('MMM dd').format(data.timestamp);
    String timeStr = DateFormat('HH:mm').format(data.timestamp);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: () => _showDetailsDialog(context),
          borderRadius: BorderRadius.circular(24),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Container(
                  width: 80,
                  color: AppColors.ecgGreen.withValues(alpha: 0.1),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        dateStr,
                        style: AppTheme.textTheme.titleSmall?.copyWith(
                          color: AppColors.ecgGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        timeStr,
                        style: AppTheme.textTheme.bodySmall?.copyWith(
                          color: AppColors.ecgGreen.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data.name,
                                        style: AppTheme.textTheme.titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      Text(
                                        '${data.gender} • ${data.age} ${AppStrings.years}',
                                        style: AppTheme.textTheme.bodySmall
                                            ?.copyWith(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  // Delete button (IconButton inside InkWell is fine as long as we stop propagation if needed, but Flutter handles nested buttons well)
                                  IconButton(
                                    onPressed: () {
                                      if (data.id != null) {
                                        _showDeleteDialog(context);
                                      }
                                    },
                                    icon: const Icon(Icons.delete, size: 22),
                                    color: Colors.red.shade600,
                                    style: IconButton.styleFrom(
                                      backgroundColor: Colors.red.shade50,
                                    ),
                                    tooltip: AppStrings.deleteRecord,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Divider(height: 1),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildMetric(
                              context,
                              Icons.speed,
                              '${data.bloodPressure.systolic.toInt()}/${data.bloodPressure.diastolic.toInt()}',
                              AppStrings.unitMmHg,
                              AppColors.bpAmber,
                            ),
                            _buildMetric(
                              context,
                              Icons.favorite,
                              '${data.oximeter.heartRate}',
                              AppStrings.unitBpm,
                              AppColors.heartRateRed,
                            ),
                            _buildMetric(
                              context,
                              Icons.water_drop,
                              '${data.oximeter.spo2}',
                              AppStrings.unitPercentage,
                              AppColors.spo2Cyan,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetric(
    BuildContext context,
    IconData icon,
    String value,
    String unit,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          unit,
          style: AppTheme.textTheme.labelSmall?.copyWith(color: Colors.grey),
        ),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => DeleteConfirmationDialog(
        patient: data,
        onDelete: () {
          context.read<HistoryCubit>().deletePatientRecord(data.id!);
        },
      ),
    );
  }

  void _showDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => PatientDetailsDialog(
        patient: data,
        onAnalysis: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AnalysisScreen(patient: data),
            ),
          );
        },
      ),
    );
  }
}
