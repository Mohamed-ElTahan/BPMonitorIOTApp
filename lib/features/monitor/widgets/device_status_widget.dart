import 'package:flutter/material.dart';

class DeviceStatusWidget extends StatelessWidget {
  final bool isOnline;

  const DeviceStatusWidget({super.key, required this.isOnline});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isOnline ? Icons.power : Icons.power_off,
            color: isOnline ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 8),
          Text(
            "Device: ${isOnline ? "Online" : "Offline"}",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isOnline ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
