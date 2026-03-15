import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/monitor_cubit.dart';
import '../cubit/monitor_state.dart';
import 'monitor_screen_selectors.dart';
import 'vitals_row_widget.dart';

class VitalsPanel extends StatelessWidget {
  const VitalsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<MonitorCubit, MonitorState, VitalsSnapshot>(
      selector: (state) {
        if (state is MonitorConnected) {
          return VitalsSnapshot(
            hr: state.currentVitals.oximeter.heartRate,
            spo2: state.currentVitals.oximeter.spo2,
            sys: state.currentVitals.bloodPressure.systolic,
            dia: state.currentVitals.bloodPressure.diastolic,
            livePressure: state.currentVitals.livePressure,
          );
        }
        return const VitalsSnapshot.empty();
      },
      builder: (context, snapshot) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          VitalsRowWidget(
            livePressure: snapshot.livePressure,
            sys: snapshot.sys,
            dia: snapshot.dia,
            hr: snapshot.hr,
            spo2: snapshot.spo2,
          ),
        ],
      ),
    );
  }
}
