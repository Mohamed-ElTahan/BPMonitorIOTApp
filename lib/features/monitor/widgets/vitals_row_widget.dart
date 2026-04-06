import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../cubit/bp_estimator.dart';
import 'vitals_card.dart';

class VitalsRowWidget extends StatelessWidget {
  final List<double> livePressure;
  final double sys;
  final double dia;
  final int hr;
  final int spo2;

  const VitalsRowWidget({
    super.key,
    required this.livePressure,
    required this.sys,
    required this.dia,
    required this.hr,
    required this.spo2,
  });

  @override
  Widget build(BuildContext context) {
    final double halfWidth = (MediaQuery.of(context).size.width - 40) / 2;
    // For 3 elements in a row with spacing 8 and padding 16: 16 + 8 + 8 = 32.
    // Let's use 40 just to be safe so it doesn't wrap unexpectedly.
    final double thirdWidth = (MediaQuery.of(context).size.width - 40) / 3;
    final estimatedBp = BpEstimator.estimate(hr, spo2);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        SizedBox(
          width: halfWidth,
          child: VitalsCard(
            title: AppStrings.livePressure,
            value: livePressure.isNotEmpty
                ? livePressure.last.toStringAsFixed(1)
                : "--",
            subtitle: AppStrings.unitMmHg,
            color: AppColors.spo2Cyan,
            icon: Icons.compress,
          ),
        ),
        SizedBox(
          width: halfWidth,
          child: VitalsCard(
            title: AppStrings.bloodPressure,
            value: "${sys.toStringAsFixed(1)}/${dia.toStringAsFixed(1)}",
            subtitle: AppStrings.unitMmHg,
            color: AppColors.bpAmber,
            icon: Icons.speed,
          ),
        ),
        SizedBox(
          width: thirdWidth,
          child: VitalsCard(
            title: AppStrings.heartRate,
            value: hr.toInt().toString(),
            subtitle: AppStrings.unitBpm,
            color: AppColors.heartRateRed,
            icon: Icons.heart_broken_outlined,
          ),
        ),
        SizedBox(
          width: thirdWidth,
          child: VitalsCard(
            title: AppStrings.oxygen,
            value: "${spo2.toString()}%",
            subtitle: AppStrings.spo2,
            color: AppColors.spo2Cyan,
            icon: Icons.water_drop,
          ),
        ),
        SizedBox(
          width: thirdWidth,
          child: VitalsCard(
            title: AppStrings.estimatedBp,
            value:
                "${estimatedBp.systolic.toStringAsFixed(0)}/${estimatedBp.diastolic.toStringAsFixed(0)}",
            subtitle: AppStrings.unitMmHg,
            color: Colors.deepPurpleAccent,
            icon: Icons.analytics,
          ),
        ),
      ],
    );
  }
}
