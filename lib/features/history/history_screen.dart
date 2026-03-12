import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bp_monitor_iot/core/constants/app_strings.dart';
import 'package:bp_monitor_iot/core/theme/app_colors.dart';
import 'package:bp_monitor_iot/core/theme/app_theme.dart';
import 'package:bp_monitor_iot/features/history/repository/history_repository.dart';
import 'cubit/history_cubit.dart';
import 'cubit/history_state.dart';
import 'widgets/history_card.dart';
import 'widgets/no_history_widget.dart';
import 'package:bp_monitor_iot/core/widgets/snackbars/app_snackbars.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          HistoryCubit(context.read<HistoryRepository>())..loadHistory(),
      child: const _HistoryScreen(),
    );
  }
}

class _HistoryScreen extends StatelessWidget {
  const _HistoryScreen();

  @override
  Widget build(BuildContext context) {
    return BlocListener<HistoryCubit, HistoryState>(
      listener: (context, state) {
        if (state is HistoryDeleteSuccess) {
          AppSnackbars.showSuccess(context, AppStrings.historyDeleteSuccess);
        } else if (state is HistoryDeleteFailure) {
          AppSnackbars.showError(
              context, '${AppStrings.historyDeleteFailure}${state.message}');
        }
      },
      child: RefreshIndicator(
        onRefresh: () =>
            context.read<HistoryCubit>().loadHistory(isRefresh: true),
        color: AppColors.ecgGreen,
        child: BlocBuilder<HistoryCubit, HistoryState>(
          buildWhen: (prev, curr) =>
              curr is HistoryLoading ||
              curr is HistoryLoaded ||
              curr is HistoryError,
          builder: (context, state) {
            switch (state) {
              case HistoryLoading():
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.ecgGreen),
                );

              case HistoryError():
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 60,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppStrings.historyLoadFailure,
                        style: AppTheme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: AppTheme.textTheme.bodySmall,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () =>
                            context.read<HistoryCubit>().loadHistory(),
                        child: const Text(AppStrings.retry),
                      ),
                    ],
                  ),
                );

              case HistoryLoaded():
                if (state.history.isEmpty) {
                  return const NoHistoryWidget();
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.history.length,
                  itemBuilder: (context, index) {
                    return HistoryCard(data: state.history[index]);
                  },
                );

              case HistoryDeleteSuccess():
              case HistoryDeleteFailure():
                return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
