import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/cubits/mqtt_connection_cubit.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/wifi_status_widget.dart';
import 'package:bp_monitor_iot/features/main_scaffold/cubit/navigation_cubit.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const MainAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          Text(AppStrings.appName,
              style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
      actions: [
        // WiFi status — always visible on all screens
        const Padding(
          padding: EdgeInsets.only(right: 6),
          child: WifiStatusWidget(),
        ),
        // MQTT broker status — only on Monitor screen (index 0)
        BlocBuilder<NavigationCubit, int>(
          builder: (context, index) {
            if (index != 0) return const SizedBox.shrink();

            return BlocBuilder<MqttConnectionCubit, MqttConnectionStatus>(
              builder: (context, status) {
                final isConnected = status == MqttConnectionStatus.connected;
                final isConnecting = status == MqttConnectionStatus.connecting;
                final color = isConnected
                    ? const Color.fromARGB(255, 9, 255, 1)
                    : (isConnecting ? Colors.orangeAccent : Colors.redAccent);
                final statusText = isConnected
                    ? AppStrings.brokerOnline
                    : (isConnecting
                        ? AppStrings.brokerConnecting
                        : AppStrings.brokerOffline);

                return Container(
                  margin: const EdgeInsets.only(right: 16),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: color.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: color.withValues(alpha: 0.4),
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        statusText,
                        style: TextStyle(
                          color: color.withValues(alpha: 0.9),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
