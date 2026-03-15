import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/dialogs/patient_info_dialog.dart';
import '../cubit/monitor_cubit.dart';
import '../cubit/monitor_state.dart';
import 'monitor_controls_widget.dart';
import 'monitor_screen_selectors.dart';

class ControlsPanel extends StatelessWidget {
  const ControlsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<MonitorCubit, MonitorState, ControlsSnapshot>(
      selector: (state) {
        if (state is MonitorConnected) {
          return ControlsSnapshot(
            isConnected: true,
            isMeasuring: state.isMeasuring,
            isSaving: state is MonitorSaving,
          );
        }
        return const ControlsSnapshot(
          isConnected: false,
          isMeasuring: false,
          isSaving: false,
        );
      },
      builder: (context, snapshot) => MonitorControlsWidget(
        isConnected: snapshot.isConnected,
        isMeasuring: snapshot.isMeasuring,
        isSaving: snapshot.isSaving,
        onStart: () => context.read<MonitorCubit>().startMeasurement(),
        onStop: () => context.read<MonitorCubit>().stopMeasurement(),
        onSave: () async {
          final result = await showDialog<Map<String, dynamic>>(
            context: context,
            builder: (context) => const PatientInfoDialog(),
          );
          if (result != null && context.mounted) {
            context.read<MonitorCubit>().saveVitals(
              name: result['name'] as String,
              gender: result['gender'] as String,
              age: result['age'] as int,
            );
          }
        },
      ),
    );
  }
}
