import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../cubit/monitor_cubit.dart';
import '../cubit/monitor_state.dart';

class ConnectionStatus extends StatelessWidget {
  const ConnectionStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MonitorCubit, MonitorState>(
      builder: (context, state) {
        Color statusColor = AppColors.disconnected;
        String statusText = "Disconnected";
        if (state is MonitorConnected) {
          statusColor = AppColors.connected;
          statusText = "Connected";
        } else if (state is MonitorConnecting) {
          statusColor = AppColors.connecting;
          statusText = "Connecting...";
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(statusText, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        );
      },
    );
  }
}
