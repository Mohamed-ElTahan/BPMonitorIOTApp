import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/services/firebase_service.dart';
import '../../core/theme/app_colors.dart';
import '../monitor/models/vitals_model.dart';

class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FutureBuilder<List<VitalsModel>>(
      future: context.read<FirebaseService>().getHistoryData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: theme.colorScheme.primary),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error loading data: ${snapshot.error}',
              style: TextStyle(color: theme.colorScheme.error),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'Not enough data for analysis',
              style: theme.textTheme.bodyMedium,
            ),
          );
        }

        final data = snapshot.data!;

        // Calculate basic stats
        double avgHr = 0;
        double avgSpo2 = 0;
        double avgSys = 0;
        double avgDia = 0;

        for (var v in data) {
          avgHr += v.heartRate;
          avgSpo2 += v.spo2;
          avgSys += v.systolicBP;
          avgDia += v.diastolicBP;
        }

        avgHr /= data.length;
        avgSpo2 /= data.length;
        avgSys /= data.length;
        avgDia /= data.length;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Recent Averages (Last 50 Readings)',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              _buildStatCard(
                context,
                'Average Heart Rate',
                '${avgHr.toStringAsFixed(1)} BPM',
                Icons.favorite,
                AppColors.heartRateRed,
              ),
              const SizedBox(height: 12),
              _buildStatCard(
                context,
                'Average SpO2',
                '${avgSpo2.toStringAsFixed(1)}%',
                Icons.water_drop,
                AppColors.spo2Cyan,
              ),
              const SizedBox(height: 12),
              _buildStatCard(
                context,
                'Average BP',
                '${avgSys.toStringAsFixed(0)}/${avgDia.toStringAsFixed(0)} mmHg',
                Icons.speed,
                AppColors.bpAmber,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.bodySmall),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
