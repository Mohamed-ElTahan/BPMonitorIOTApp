import 'package:equatable/equatable.dart';
import '../models/patient_measurement_model.dart';

sealed class MonitorState extends Equatable {
  const MonitorState();

  @override
  List<Object?> get props => [];
}

class MonitorInitial extends MonitorState {
  final PatientMeasurementModel currentVitals;

  const MonitorInitial({required this.currentVitals});

  @override
  List<Object?> get props => [currentVitals];
}

class MonitorConnecting extends MonitorState {}

class MonitorConnected extends MonitorState {
  final PatientMeasurementModel currentVitals;
  final bool isMeasuring;

  const MonitorConnected({
    required this.currentVitals,
    this.isMeasuring = false,
  });

  MonitorConnected copyWithState({
    PatientMeasurementModel? currentVitals,
    bool? isMeasuring,
  }) {
    return MonitorConnected(
      currentVitals: currentVitals ?? this.currentVitals,
      isMeasuring: isMeasuring ?? this.isMeasuring,
    );
  }

  @override
  List<Object?> get props => [currentVitals, isMeasuring];
}

/// Emitted while a Firestore save is in progress.
/// Extends [MonitorConnected] so the UI continues to display live vitals.
class MonitorSaving extends MonitorConnected {
  const MonitorSaving({
    required super.currentVitals,
    super.isMeasuring,
  });
}

/// Emitted once the Firestore save resolves (success or failure).
class MonitorSaveResult extends MonitorConnected {
  final bool success;
  final String? error;

  const MonitorSaveResult({
    required super.currentVitals,
    super.isMeasuring,
    required this.success,
    this.error,
  });

  @override
  List<Object?> get props => [
    ...super.props,
    success,
    error,
  ];
}

class MonitorDisconnected extends MonitorState {
  const MonitorDisconnected();

  @override
  List<Object?> get props => [];
}
