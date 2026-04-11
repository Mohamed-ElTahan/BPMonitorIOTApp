import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import 'model/list_team_member.dart';
import 'widgets/member_card.dart';

class TeamInfoScreen extends StatelessWidget {
  const TeamInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.teamInfo), centerTitle: true),

      // TODO: upload data to firebase
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     await FirestoreDataSource().seedAllProfiles();
      //     if (context.mounted) {
      //       ScaffoldMessenger.of(context).showSnackBar(
      //         const SnackBar(content: Text('Data seeded successfully!')),
      //       );
      //     }
      //   },
      //   child: const Icon(Icons.cloud_upload),
      // ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double itemWidth = (constraints.maxWidth - 20 - 10) / 2;
          final double itemHeight = (constraints.maxHeight - 20 - 10) / 3;
          final double childAspectRatio = itemWidth / itemHeight;

          return GridView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: ListTeamMember.teamData.length,
            physics: const ScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: childAspectRatio,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) =>
                MemberCard(member: ListTeamMember.teamData[index]),
          );
        },
      ),
    );
  }
}
