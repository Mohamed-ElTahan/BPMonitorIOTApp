import '../../monitor/models/vitals_model.dart';

abstract class HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<VitalsModel> history;
  HistoryLoaded(this.history);
}

class HistoryError extends HistoryState {
  final String message;
  HistoryError(this.message);
}
