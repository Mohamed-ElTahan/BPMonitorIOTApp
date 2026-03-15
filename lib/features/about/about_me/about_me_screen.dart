import 'package:bp_monitor_iot/features/about/team/model/member_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_strings.dart';
import 'cubit/about_me_cubit.dart';
import 'cubit/about_me_state.dart';
import 'widgets/bio_card.dart';
import 'widgets/profile_header.dart';
import 'widgets/social_button.dart';

class AboutMeScreen extends StatelessWidget {
  final MemberModel memberModel;
  const AboutMeScreen({super.key, required this.memberModel});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AboutMeCubit()..fetchProfile(memberModel.name),
      child: _AboutMeScreen(memberModel: memberModel),
    );
  }
}

class _AboutMeScreen extends StatelessWidget {
  final MemberModel memberModel;
  const _AboutMeScreen({required this.memberModel});

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.aboutMe)),
      body: BlocBuilder<AboutMeCubit, AboutMeState>(
        builder: (context, state) {
          if (state is AboutMeLoading || state is AboutMeInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AboutMeError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 12),
                  Text(
                    'Failed to load profile',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => context.read<AboutMeCubit>().fetchProfile(
                      memberModel.name,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is AboutMeLoaded) {
            final profile = state.profileModel;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),

                    // Profile Header
                    ProfileHeader(
                      name: profile.name,
                      role: profile.role,
                      image: memberModel.imagePath,
                    ),

                    const SizedBox(height: 24),

                    // Bio
                    BioCard(bio: profile.bio),

                    const SizedBox(height: 24),

                    // Social Links
                    Wrap(
                      spacing: 20,
                      runSpacing: 16,
                      alignment: WrapAlignment.center,
                      children: [
                        // GitHub
                        if (profile.githubUrl.isNotEmpty)
                          SocialButton(
                            assetPath: 'assets/icons/github.svg',
                            label: 'GitHub',
                            onTap: () => _launch(profile.githubUrl),
                          ),

                        // Email
                        if (profile.email.isNotEmpty)
                          SocialButton(
                            assetPath: 'assets/icons/gmail.svg',
                            label: 'Email',
                            onTap: () {
                              final uri = Uri(
                                scheme: 'mailto',
                                path: profile.email,
                                query: _encodeQuery({'subject': 'CSBPM'}),
                              );
                              _launch(uri.toString());
                            },
                          ),

                        // LinkedIn
                        if (profile.linkedInUrl.isNotEmpty)
                          SocialButton(
                            assetPath: 'assets/icons/linkedin.svg',
                            label: 'LinkedIn',
                            onTap: () => _launch(profile.linkedInUrl),
                          ),

                        // WhatsApp
                        if (profile.whatsappNumber.isNotEmpty)
                          SocialButton(
                            assetPath: 'assets/icons/whatsapp.svg',
                            label: 'WhatsApp',
                            onTap: () => _launch(
                              'https://wa.me/${profile.whatsappNumber}',
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  String _encodeQuery(Map<String, String> params) {
    return params.entries
        .map(
          (e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');
  }
}
