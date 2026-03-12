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

  @override
  List<Object?> get props => [message];
}

class HistoryDeleteSuccess extends HistoryState {
  const HistoryDeleteSuccess();
}

class HistoryDeleteFailure extends HistoryState {
  final String message;
  const HistoryDeleteFailure(this.message);

  @override
  List<Object?> get props => [message];
}
