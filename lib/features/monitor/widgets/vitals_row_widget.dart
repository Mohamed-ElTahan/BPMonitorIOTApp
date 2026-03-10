import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
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
    final theme = Theme.of(context);
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        SizedBox(
          width: (MediaQuery.of(context).size.width - 44) / 2,
          child: VitalsCard(
            title: "Live Pressure",
            value: livePressure.isNotEmpty
                ? livePressure.last.toStringAsFixed(1)
                : "--",
            subtitle: "mmHg",
            color: theme.colorScheme.secondary,
            icon: Icons.compress,
          ),
        ),
        SizedBox(
          width: (MediaQuery.of(context).size.width - 44) / 2,
          child: VitalsCard(
            title: "Blood Pressure",
            value: "${sys.toStringAsFixed(1)}/${dia.toStringAsFixed(1)}",
            subtitle: "mmHg",
            color: AppColors.bpAmber,
            icon: Icons.speed,
          ),
        ),
        SizedBox(
          width: (MediaQuery.of(context).size.width - 44) / 2,
          child: VitalsCard(
            title: "Heart Rate",
            value: "${hr.toInt()} BPM",
            color: AppColors.heartRateRed,
            icon: Icons.favorite,
          ),
        ),
        SizedBox(
          width: (MediaQuery.of(context).size.width - 44) / 2,
          child: VitalsCard(
            title: "SpO2",
            value: "$spo2%",
            color: AppColors.spo2Cyan,
            icon: Icons.water_drop,
          ),
        ),
      ],
    );
  }
}
