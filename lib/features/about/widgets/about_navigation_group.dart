import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../supervisor/supervisor_screen.dart';
import '../team/team_info_screen.dart';
import 'about_navigation_card.dart';

class AboutNavigationGroup extends StatelessWidget {
  const AboutNavigationGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCards(context)[0],
        const SizedBox(height: 16),
        _buildCards(context)[1],
      ],
    );
  }

  List<AboutNavigationCard> _buildCards(BuildContext context) {
    return [
      AboutNavigationCard(
        title: AppStrings.teamInfo,
        subtitle: AppStrings.teamInfoSubtitle,
        icon: Icons.groups_rounded,
        color: AppColors.ecgGreen,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TeamInfoScreen()),
        ),
      ),
      AboutNavigationCard(
        title: AppStrings.supervisor,
        subtitle: AppStrings.supervisorSubtitle,
        icon: Icons.engineering,
        color: AppColors.heartRateRed,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SupervisorScreen()),
        ),
      ),
    ];
  }
}
