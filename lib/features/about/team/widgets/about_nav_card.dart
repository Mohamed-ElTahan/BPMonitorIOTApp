import 'package:flutter/material.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';

class AboutNavCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const AboutNavCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = context.responsive(mobile: 20.0, tablet: 28.0);
    final verticalPadding = context.responsive(mobile: 20.0, tablet: 28.0);
    final iconSize = context.responsive(mobile: 24.0, tablet: 32.0);
    final iconContainerSize = context.responsive(mobile: 48.0, tablet: 60.0);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.05),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            child: Row(
              children: [
                Container(
                  width: iconContainerSize,
                  height: iconContainerSize,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: iconSize),
                ),
                SizedBox(width: context.responsive(mobile: 20, tablet: 30)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: context.responsive(mobile: 16, tablet: 20),
                        ),
                      ),
                      SizedBox(height: context.responsive(mobile: 6, tablet: 10)),
                      Text(
                        subtitle,
                        style: AppTheme.textTheme.bodySmall?.copyWith(
                          color: AppColors.lightTextSecondary,
                          fontSize: context.responsive(mobile: 12, tablet: 15),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: context.responsive(mobile: 14, tablet: 18),
                  color: AppColors.lightTextSecondary.withValues(alpha: 0.4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
