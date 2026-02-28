import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import 'cubit/history_cubit.dart';
import 'cubit/history_state.dart';
import 'widgets/history_card.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<HistoryCubit>().loadHistory(),
      color: AppColors.ecgGreen,
      child: BlocBuilder<HistoryCubit, HistoryState>(
        builder: (context, state) {
          if (state is HistoryLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.ecgGreen),
            );
          } else if (state is HistoryError) {
            return Center(
              child: Text(
                'Error loading history: ${state.message}',
                style: const TextStyle(color: AppColors.heartRateRed),
              ),
            );
          } else if (state is HistoryLoaded) {
            final pastVitals = state.history;
            if (pastVitals.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: 200),
                  Center(
                    child: Text(
                      'No history available',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              );
            }
            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: pastVitals.length,
              itemBuilder: (context, index) {
                return HistoryCard(vitals: pastVitals[index]);
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
