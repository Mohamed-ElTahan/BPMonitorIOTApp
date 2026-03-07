import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import 'cubit/history_cubit.dart';
import 'cubit/history_state.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HistoryCubit()..loadHistory(),
      child: const _HistoryScreen(),
    );
  }
}

class _HistoryScreen extends StatelessWidget {
  const _HistoryScreen();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<HistoryCubit>().loadHistory(),
      color: AppColors.ecgGreen,
      child: BlocBuilder<HistoryCubit, HistoryState>(
        builder: (context, state) => const Center(
          child: CircularProgressIndicator(color: AppColors.ecgGreen),
        ),
      ),
    );
  }
}
