import 'package:equatable/equatable.dart';
import '../../data/models/vitals_model.dart';

abstract class MonitorState extends Equatable {
  const MonitorState();

  @override
  List<Object> get props => [];
}

class MonitorInitial extends MonitorState {}

class MonitorConnecting extends MonitorState {}

class MonitorConnected extends MonitorState {
  final VitalsModel currentVitals;
  final List<double> ecgHistory;

  const MonitorConnected({
    required this.currentVitals,
    required this.ecgHistory,
  });

  @override
  List<Object> get props => [currentVitals, ecgHistory];

  MonitorConnected copyWith({
    VitalsModel? currentVitals,
    List<double>? ecgHistory,
  }) {
    return MonitorConnected(
      currentVitals: currentVitals ?? this.currentVitals,
      ecgHistory: ecgHistory ?? this.ecgHistory,
    );
  }
}

class MonitorDisconnected extends MonitorState {
  final String? message;

  const MonitorDisconnected({this.message});

  @override
  List<Object> get props => [message ?? ''];
}
