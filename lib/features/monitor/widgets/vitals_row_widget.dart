import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../cubit/monitor_cubit.dart';
import '../cubit/monitor_state.dart';
import 'vitals_card.dart';

class VitalsRowWidget extends StatelessWidget {
  const VitalsRowWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MonitorCubit, MonitorState>(
      builder: (context, state) {
        int hr = 0;
        int spo2 = 0;
        int sys = 0;
        int dia = 0;

        if (state is MonitorConnected) {
          hr = state.currentVitals.heartRate;
          spo2 = state.currentVitals.spo2;
          sys = state.currentVitals.systolicBP;
          dia = state.currentVitals.diastolicBP;
        }

        return Row(
          children: [
            Expanded(
              child: VitalsCard(
                title: "Heart Rate",
                value: "$hr BPM",
                color: AppColors.heartRateRed,
                icon: Icons.favorite,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: VitalsCard(
                title: "SpO2",
                value: "$spo2%",
                color: AppColors.spo2Cyan,
                icon: Icons.water_drop,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: VitalsCard(
                title: "Blood Pressure",
                value: "$sys/$dia",
                subtitle: "mmHg",
                color: AppColors.bpAmber,
                icon: Icons.speed,
              ),
            ),
          ],
        );
      },
    );
  }
}
