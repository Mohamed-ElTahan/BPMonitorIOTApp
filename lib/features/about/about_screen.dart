import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.monitor_heart,
              size: 80,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text('BP Monitor IoT', style: theme.textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text('Version 1.0.0', style: theme.textTheme.bodySmall),
            const Spacer(),
            Text(
              'A comprehensive IoT application for monitoring blood pressure, heart rate, oxygen saturation, and continuous ECG waveforms. Connect seamlessly to a smart monitor to track your vitals in real-time and review historical data analysis.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
            const Spacer(flex: 2),
            Text(
              '© ${DateTime.now().year} BP Monitor IoT. All rights reserved.',
              style: theme.textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }
}
