import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/monitor_cubit.dart';
import 'cubit/monitor_state.dart';
import 'repository/monitor_repository.dart';
import '../../core/constants/app_strings.dart';
import '../../core/data_source/firebase/firestore_data_source.dart';
import '../../core/utils/snackbars/app_snackbars.dart';
import 'widgets/saving_overlay_widget.dart';
import 'widgets/vitals_panel.dart';
import 'widgets/charts_panel.dart';
import 'widgets/controls_panel.dart';

class MonitorScreen extends StatelessWidget {
  const MonitorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MonitorCubit(
        context.read<MonitorRepository>(),
        context.read<FirestoreDataSource>(),
      )..initialize(),
      child: const _MonitorScreen(),
    );
  }
}

class _MonitorScreen extends StatelessWidget {
  const _MonitorScreen();

  @override
  Widget build(BuildContext context) {
    return BlocListener<MonitorCubit, MonitorState>(
      listenWhen: (_, current) => current is MonitorSaveResult,
      listener: (context, state) {
        if (state is MonitorSaveResult) {
          if (state.success) {
            AppSnackbars.showSuccess(
              context,
              AppStrings.measurementSavedSuccess,
            );
          } else {
            AppSnackbars.showError(
              context,
              '${AppStrings.measurementSavedFailure}${state.error ?? 'Unknown error'}',
            );
          }
        }
      },
      child: Stack(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                // ── Vitals region ─────────────────────────────────────────
                VitalsPanel(),

                SizedBox(height: 10),

                // ── Charts region (ECG/BP PageView) ───────────────────────
                Expanded(child: ChartsPanel()),

                SizedBox(height: 16),

                // ── Controls ──────────────────────────────────────────────
                ControlsPanel(),
              ],
            ),
          ),

          // ── Saving overlay ────────────────────────────────────────────
          BlocBuilder<MonitorCubit, MonitorState>(
            buildWhen: (prev, curr) =>
                (prev is MonitorSaving) != (curr is MonitorSaving),
            builder: (context, state) {
              if (state is! MonitorSaving) return const SizedBox.shrink();
              return const SavingOverlayWidget();
            },
          ),
        ],
      ),
    );
  }
}
