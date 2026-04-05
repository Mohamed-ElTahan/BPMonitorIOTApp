import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/context_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

class AboutAppHeader extends StatelessWidget {
  const AboutAppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final iconSize = context.responsive(mobile: 130.0, tablet: 180.0);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
        );
      },
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              // Subtle background glow
              Container(
                width: iconSize * 1.1,
                height: iconSize * 1.1,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.ecgGreen.withValues(alpha: 0.2),
                      AppColors.ecgGreen.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.ecgGreen.withValues(alpha: 0.15),
                      blurRadius: 30,
                      offset: const Offset(0, 12),
                    ),
                  ],
                  border: Border.all(
                    color: AppColors.ecgGreen.withValues(alpha: 0.1),
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/icons/CSBPM_icon.jpeg',
                    width: iconSize,
                    height: iconSize,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: context.responsive(mobile: 12, tablet: 24)),
          Text(
            AppStrings.appName,
            textAlign: TextAlign.center,
            style: AppTheme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w900,
              fontSize: context.responsive(mobile: 32, tablet: 48),
              letterSpacing: -0.5,
              color: Theme.of(context).textTheme.headlineMedium?.color,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 4,
            width: 60,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.ecgGreen, AppColors.spo2Cyan],
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}
