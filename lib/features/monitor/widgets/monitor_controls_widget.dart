import 'package:flutter/material.dart';

class MonitorControlsWidget extends StatelessWidget {
  final bool isConnected;
  final VoidCallback? onStart;
  final VoidCallback? onStop;

  const MonitorControlsWidget({
    super.key,
    required this.isConnected,
    this.onStart,
    this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: isConnected ? onStart : null,
          icon: const Icon(Icons.play_arrow),
          label: const Text('Start'),
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.surface,
          ),
        ),
        const SizedBox(width: 24),
        ElevatedButton.icon(
          onPressed: isConnected ? onStop : null,
          icon: const Icon(Icons.stop),
          label: const Text('Stop'),
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.error,
            foregroundColor: theme.colorScheme.surface,
          ),
        ),
      ],
    );
  }
}
