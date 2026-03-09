import 'package:equatable/equatable.dart';

import '../model/patient_model.dart';

sealed class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object?> get props => [];
}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<PatientModel> history;
  const HistoryLoaded(this.history);
}

class HistoryError extends HistoryState {
  final String message;
  const HistoryError(this.message);
}
