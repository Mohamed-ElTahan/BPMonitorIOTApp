import 'package:flutter/material.dart';

class FloatActionButtonWidget extends StatelessWidget {
  final VoidCallback onTap;
  const FloatActionButtonWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FloatingActionButton(
      onPressed: onTap,
      backgroundColor: theme.cardTheme.color,
      tooltip: 'Reconnect MQTT',
      child: Icon(Icons.refresh, color: theme.colorScheme.primary),
    );
  }
}
