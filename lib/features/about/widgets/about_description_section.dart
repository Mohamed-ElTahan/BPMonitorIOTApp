import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/context_extension.dart';
import '../../../core/theme/app_theme.dart';

class AboutDescriptionSection extends StatelessWidget {
  const AboutDescriptionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.responsive(mobile: 8.0, tablet: 20.0),
      ),
      child: Text(
        AppStrings.aboutDescription,
        textAlign: TextAlign.center,
        style: AppTheme.textTheme.bodyMedium?.copyWith(
          fontSize: context.responsive(mobile: 16, tablet: 20),
          height: 1.6,
          letterSpacing: 0.2,
          color: Theme.of(
            context,
          ).textTheme.bodyMedium?.color?.withValues(alpha: 0.8),
        ),
      ),
    );
  }
}
