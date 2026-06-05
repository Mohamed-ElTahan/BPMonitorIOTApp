import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../cubit/bp_estimator.dart';

class VitalsColumnWidget extends StatelessWidget {
  final List<double> livePressure;
  final double sys;
  final double dia;
  final int hr;
  final int spo2;

  const VitalsColumnWidget({
    super.key,
    required this.livePressure,
    required this.sys,
    required this.dia,
    required this.hr,
    required this.spo2,
  });

  @override
  Widget build(BuildContext context) {
    final estimatedBp = BpEstimator.estimate(hr, spo2);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          child: VitalsCardCol(
            title: AppStrings.livePressure,
            value: livePressure.isNotEmpty
                ? livePressure.last.toStringAsFixed(1)
                : "0",
            unit: AppStrings.unitMmHg,
            iconColor: AppColors.spo2Cyan,
            icon: Icons.compress,
          ),
        ),
        SizedBox(
          child: VitalsCardCol(
            title: AppStrings.bloodPressure,
            value: "${sys.toStringAsFixed(0)}/${dia.toStringAsFixed(0)}",
            unit: AppStrings.unitMmHg,
            iconColor: AppColors.bpAmber,
            icon: Icons.speed,
          ),
        ),
        SizedBox(
          child: VitalsCardCol(
            title: AppStrings.heartRate,
            value: hr.toString(),
            unit: AppStrings.unitBpm,
            iconColor: AppColors.heartRateRed,
            icon: Icons.heart_broken_outlined,
          ),
        ),
        SizedBox(
          child: VitalsCardCol(
            title: AppStrings.oxygen,
            value: "${spo2.toString()}%",
            unit: AppStrings.spo2,
            iconColor: AppColors.spo2Cyan,
            icon: Icons.water_drop,
          ),
        ),
        SizedBox(
          child: VitalsCardCol(
            title: AppStrings.estimatedBp,
            value:
                "${estimatedBp.systolic.toStringAsFixed(0)}/${estimatedBp.diastolic.toStringAsFixed(0)}",
            unit: AppStrings.unitMmHg,
            iconColor: Colors.deepPurpleAccent,
            icon: Icons.analytics,
          ),
        ),
      ],
    );
  }
}

class VitalsCardCol extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final Color iconColor;
  final IconData icon;

  const VitalsCardCol({
    super.key,
    required this.title,
    required this.value,
    required this.unit,
    required this.iconColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TitleRow(title: title, icon: icon, iconColor: iconColor),

            // Value
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: const Color.fromARGB(255, 4, 0, 252),
              ),
            ),

            // Unit
            Text(
              unit,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TitleRow extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;

  const TitleRow({
    super.key,
    required this.title,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: iconColor, size: 30),
        const SizedBox(width: 6),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 22,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
