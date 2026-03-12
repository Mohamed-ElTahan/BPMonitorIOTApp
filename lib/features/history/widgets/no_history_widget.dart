import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_theme.dart';

class NoHistoryWidget extends StatelessWidget {
  const NoHistoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history_outlined,
            color: Colors.grey.withValues(alpha: 0.5),
            size: 80,
          ),
          const SizedBox(height: 16),
          Text(
            AppStrings.historyEmptyTitle,
            style: AppTheme.textTheme.titleMedium?.copyWith(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppStrings.historyEmptySubtitle,
            style: AppTheme.textTheme.bodySmall?.copyWith(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

