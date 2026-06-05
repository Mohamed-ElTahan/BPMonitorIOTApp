import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../about_me/widgets/bio_card.dart';
import '../../about_me/widgets/profile_header.dart';
import '../model/supervisor_model.dart';

class SupervisorAbout extends StatelessWidget {
  final SupervisorModel supervisorModel;
  const SupervisorAbout({super.key, required this.supervisorModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.aboutMe)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // Profile Header
              ProfileHeader(
                name: supervisorModel.name,
                role: supervisorModel.role,
                image: supervisorModel.image,
              ),

              const SizedBox(height: 24),

              // Bio
              BioCard(bio: supervisorModel.bio),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
