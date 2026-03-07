import 'package:equatable/equatable.dart';

import '../models/patient_measurement_model.dart';

sealed class MonitorState extends Equatable {
  const MonitorState();

  @override
  List<Object?> get props => [];
}

class MonitorInitial extends MonitorState {}

class MonitorConnecting extends MonitorState {}

class MonitorConnected extends MonitorState {
  final PatientMeasurementModel currentVitals;

  const MonitorConnected({required this.currentVitals});

  @override
  List<Object?> get props => [currentVitals];
}

class MonitorDisconnected extends MonitorState {
  const MonitorDisconnected();

  @override
  List<Object?> get props => [];
}
