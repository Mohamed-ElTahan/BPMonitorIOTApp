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
  final int currentChartIndex;
  final bool isBPMeasuring;
  final bool isOxiMeasuring;
  final bool isECGMeasuring;

  const MonitorConnected({
    required this.currentVitals,
    this.currentChartIndex = 0,
    bool isMeasuring = false,
    bool isBPMeasuring = false,
    bool isOxiMeasuring = false,
    bool isECGMeasuring = false,
  }) : isBPMeasuring = isMeasuring || isBPMeasuring,
       isOxiMeasuring = isMeasuring || isOxiMeasuring,
       isECGMeasuring = isMeasuring || isECGMeasuring;

  /// Computed property that returns true if ANY measurement is active.
  /// Maintained for backward compatibility with UI components.
  bool get isMeasuring => isBPMeasuring || isOxiMeasuring || isECGMeasuring;

  MonitorConnected copyWithState({
    PatientMeasurementModel? currentVitals,
    int? currentChartIndex,
    bool? isBPMeasuring,
    bool? isOxiMeasuring,
    bool? isECGMeasuring,
    bool? isMeasuring, // Added for compatibility with existing code
  }) {
    return MonitorConnected(
      currentVitals: currentVitals ?? this.currentVitals,
      currentChartIndex: currentChartIndex ?? this.currentChartIndex,
      isBPMeasuring: isMeasuring ?? isBPMeasuring ?? this.isBPMeasuring,
      isOxiMeasuring: isMeasuring ?? isOxiMeasuring ?? this.isOxiMeasuring,
      isECGMeasuring: isMeasuring ?? isECGMeasuring ?? this.isECGMeasuring,
    );
  }

  @override
  List<Object?> get props => [
    currentVitals,
    currentChartIndex,
    isBPMeasuring,
    isOxiMeasuring,
    isECGMeasuring,
  ];
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
  List<Object?> get props => [...super.props, success, error];
}

class MonitorDisconnected extends MonitorState {
  const MonitorDisconnected();

  @override
  List<Object?> get props => [];
}
