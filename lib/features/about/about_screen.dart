import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';
import '../../core/extensions/context_extension.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import 'team/team_info_screen.dart';
import 'supervisor/supervisor_screen.dart';
import 'team/widgets/about_nav_card.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = context.responsive(mobile: 24.0, tablet: 48.0);
    final isTablet = context.width >= 600;

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: horizontalPadding,
        right: horizontalPadding,
        top: context.padding.top + 20,
        bottom: context.padding.bottom + 40,
      ),
      child: Column(
        children: [
          _buildHero(context),
          SizedBox(height: context.responsive(mobile: 20, tablet: 52)),
          _buildDescription(context),
          SizedBox(height: context.responsive(mobile: 20, tablet: 42)),
          _buildNavigationSection(context, isTablet),
          SizedBox(height: context.responsive(mobile: 30, tablet: 60)),
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildHero(BuildContext context) {
    final iconSize = context.responsive(mobile: 120.0, tablet: 150.0);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
        );
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.ecgGreen.withValues(alpha: 0.5),
              shape: BoxShape.circle,
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
          SizedBox(height: context.responsive(mobile: 12, tablet: 26)),
          Text(
            AppStrings.appName,
            textAlign: TextAlign.center,
            style: AppTheme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w900,
              fontSize: context.responsive(mobile: 28, tablet: 40),
              color: Theme.of(context).textTheme.headlineMedium?.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 2,
          width: 40,
          decoration: BoxDecoration(
            color: AppColors.ecgGreen.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(1),
          ),
        ),
        SizedBox(height: context.responsive(mobile: 10, tablet: 16)),
        Text(
          AppStrings.aboutDescription,
          textAlign: TextAlign.center,
          style: AppTheme.textTheme.bodyMedium?.copyWith(
            fontSize: context.responsive(mobile: 15, tablet: 18),
            color: Theme.of(
              context,
            ).textTheme.bodyMedium?.color?.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationSection(BuildContext context, bool isTablet) {
    final cards = [
      AboutNavCard(
        title: AppStrings.teamInfo,
        subtitle: 'Learn more about the developers',
        icon: Icons.groups_rounded,
        color: AppColors.ecgGreen,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TeamInfoScreen()),
        ),
      ),
      AboutNavCard(
        title: AppStrings.supervisor,
        subtitle: 'Academic and professional guidance',
        icon: Icons.person_pin_rounded,
        color: AppColors.heartRateRed,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SupervisorScreen()),
        ),
      ),
    ];

    if (isTablet) {
      return Row(
        children: cards
            .map(
              (card) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: card,
                ),
              ),
            )
            .toList(),
      );
    }

    return Column(
      children: [
        cards[0],
        SizedBox(height: context.responsive(mobile: 10, tablet: 20)),
        cards[1],
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Text(
      AppStrings.aboutCopyright(DateTime.now().year),
      style: AppTheme.textTheme.labelSmall?.copyWith(
        color: Theme.of(context).hintColor.withValues(alpha: 0.6),
      ),
    );
  }
}
