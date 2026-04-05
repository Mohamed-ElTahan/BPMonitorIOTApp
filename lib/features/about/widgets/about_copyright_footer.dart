import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_theme.dart';

class AboutCopyrightFooter extends StatelessWidget {
  const AboutCopyrightFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          AppStrings.aboutCopyright(DateTime.now().year),
          style: AppTheme.textTheme.labelSmall?.copyWith(
            color: Theme.of(context).hintColor.withValues(alpha: 0.6),
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
