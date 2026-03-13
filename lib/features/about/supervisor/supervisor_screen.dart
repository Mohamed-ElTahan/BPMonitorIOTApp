import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/context_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

class SupervisorScreen extends StatelessWidget {
  const SupervisorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = context.responsive(mobile: 24.0, tablet: 48.0);
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(AppStrings.supervisor),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: 32,
        ),
        child: Column(
          children: [
            _buildHero(context),
            SizedBox(height: context.responsive(mobile: 40, tablet: 60)),
            _buildSupervisorCard(
              context,
              name: AppStrings.supervisorName1,
              title: AppStrings.supervisorTitle1,
              icon: Icons.school_rounded,
              color: AppColors.heartRateRed,
            ),
            SizedBox(height: context.responsive(mobile: 20, tablet: 30)),
            _buildSupervisorCard(
              context,
              name: AppStrings.supervisorName2,
              title: AppStrings.supervisorTitle2,
              icon: Icons.psychology_rounded,
              color: AppColors.ecgGreen,
            ),
            SizedBox(height: context.responsive(mobile: 40, tablet: 60)),
            _buildDescription(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHero(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value.clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppColors.heartRateRed.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.workspace_premium_rounded,
          size: 64,
          color: AppColors.heartRateRed,
        ),
      ),
    );
  }

  Widget _buildSupervisorCard(
    BuildContext context, {
    required String name,
    required String title,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          SizedBox(width: context.responsive(mobile: 20, tablet: 30)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: context.responsive(mobile: 18, tablet: 22),
                  ),
                ),
                SizedBox(height: context.responsive(mobile: 4, tablet: 6)),
                Text(
                  title,
                  style: AppTheme.textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).dividerColor.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        AppStrings.supervisorDescription,
        textAlign: TextAlign.center,
        style: AppTheme.textTheme.bodyMedium?.copyWith(
          height: 1.6,
          color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}
