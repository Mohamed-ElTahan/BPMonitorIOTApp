import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/wifi_cubit.dart';
import 'connection_status_badge.dart';

class WifiStatusWidget extends StatelessWidget {
  const WifiStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WifiCubit, WifiStatus>(
      builder: (context, status) {
        final (connectionStatus, icon, label) = switch (status) {
          WifiStatus.wifi => (
            ConnectionStatus.connected,
            Icons.wifi_rounded,
            'WiFi'
          ),
          WifiStatus.mobile => (
            ConnectionStatus.connecting,
            Icons.signal_cellular_alt_rounded,
            'Mobile'
          ),
          WifiStatus.none => (
            ConnectionStatus.disconnected,
            Icons.wifi_off_rounded,
            'No Network'
          ),
        };

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ConnectionStatusBadge(
            status: connectionStatus,
            label: label,
            icon: icon,
          ),
        );
      },
    );
  }
}
