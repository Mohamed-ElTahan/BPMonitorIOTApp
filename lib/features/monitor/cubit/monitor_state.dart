import 'package:equatable/equatable.dart';
import '../models/vitals_model.dart';

sealed class MonitorState extends Equatable {
  const MonitorState();

  @override
  List<Object?> get props => [];
}

class MonitorInitial extends MonitorState {}

class MonitorConnecting extends MonitorState {}

class MonitorConnected extends MonitorState {
  final VitalsModel currentVitals;
  final List<double> ecgHistory;
  final String connectionStatus;
  final DateTime? lastDataReceived;

  const MonitorConnected({
    required this.currentVitals,
    required this.ecgHistory,
    required this.connectionStatus,
    this.lastDataReceived,
  });

  @override
  List<Object?> get props => [
    currentVitals,
    ecgHistory,
    connectionStatus,
    lastDataReceived,
  ];

  MonitorConnected copyWith({
    VitalsModel? currentVitals,
    List<double>? ecgHistory,
    String? connectionStatus,
    DateTime? lastDataReceived,
  }) {
    return MonitorConnected(
      currentVitals: currentVitals ?? this.currentVitals,
      ecgHistory: ecgHistory ?? this.ecgHistory,
      connectionStatus: connectionStatus ?? this.connectionStatus,
      lastDataReceived: lastDataReceived ?? this.lastDataReceived,
    );
  }
}

class MonitorDisconnected extends MonitorState {
  final String? message;

  const MonitorDisconnected({this.message});

  @override
  List<Object?> get props => [message];
}
