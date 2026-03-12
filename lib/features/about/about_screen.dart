import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.monitor_heart, size: 80, color: AppColors.ecgGreen),
            const SizedBox(height: 24),
            Text(AppStrings.appName, style: AppTheme.textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(AppStrings.version, style: AppTheme.textTheme.bodySmall),
            const Spacer(),
            Text(
              AppStrings.aboutDescription,
              textAlign: TextAlign.center,
              style: AppTheme.textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
            const Spacer(flex: 2),
            Text(
              AppStrings.aboutCopyright(DateTime.now().year),
              style: AppTheme.textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }
}
