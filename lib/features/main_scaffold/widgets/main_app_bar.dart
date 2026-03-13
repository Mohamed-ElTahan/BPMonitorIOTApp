import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/cubits/mqtt_connection_cubit.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/wifi_status_widget.dart';
import '../../../core/widgets/connection_status_badge.dart';
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
                final connectionStatus = switch (status) {
                  MqttConnectionStatus.connected => ConnectionStatus.connected,
                  MqttConnectionStatus.connecting =>
                    ConnectionStatus.connecting,
                  _ => ConnectionStatus.disconnected,
                };

                final statusText = switch (status) {
                  MqttConnectionStatus.connected => AppStrings.brokerOnline,
                  MqttConnectionStatus.connecting =>
                    AppStrings.brokerConnecting,
                  _ => AppStrings.brokerOffline,
                };

                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: ConnectionStatusBadge(
                    status: connectionStatus,
                    label: statusText,
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
