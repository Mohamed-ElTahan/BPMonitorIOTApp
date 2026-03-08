import 'package:bp_monitor_iot/features/home/cubit/home_cubit.dart';
import 'package:bp_monitor_iot/features/home/cubit/home_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/app_constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: BlocBuilder<HomeCubit, HomeStates>(
          builder: (context, state) {
            return ElevatedButton(
              onPressed: () {
                context.read<HomeCubit>().publish(
                  AppConstants.topicCommand,
                  'start',
                );
              },
              child: Text('Start'),
            );
          },
        ),
      ),
    );
  }
}
