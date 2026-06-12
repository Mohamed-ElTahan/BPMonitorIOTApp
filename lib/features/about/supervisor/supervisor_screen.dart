import 'package:bp_monitor_iot/features/about/supervisor/model/supdervisor_data.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/context_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import 'model/supervisor_model.dart';
import 'widgets/supervisor_about.dart';

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
            _buildSupervisorCard(context, supervisor: SupervisorData.drGamal),
            SizedBox(height: context.responsive(mobile: 20, tablet: 30)),
            _buildSupervisorCard(
              context,
              supervisor: SupervisorData.assLecAsmaa,
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
          child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
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
    required SupervisorModel supervisor,
  }) {
    return InkWell(
      onTap: supervisor.bio != ""
          ? () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    SupervisorAbout(supervisorModel: supervisor),
              ),
            )
          : null,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(34),
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
                color: Colors.blue.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: supervisor.image != ""
                  ? Image.asset(
                      supervisor.image,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                    )
                  : const Icon(Icons.person, size: 56, color: Colors.blue),
            ),
            SizedBox(width: context.responsive(mobile: 20, tablet: 30)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    supervisor.name,
                    style: AppTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: context.responsive(mobile: 18, tablet: 22),
                    ),
                  ),
                  SizedBox(height: context.responsive(mobile: 4, tablet: 6)),
                  Text(
                    supervisor.role,
                    style: AppTheme.textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
          color: Theme.of(
            context,
          ).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}
