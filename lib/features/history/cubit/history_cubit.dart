import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bp_monitor_iot/features/history/repository/history_repository.dart';
import 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final HistoryRepository _historyRepository;

  HistoryCubit(this._historyRepository) : super(HistoryLoading());

  Future<void> loadHistory() async {
    try {
      emit(HistoryLoading());
      final history = await _historyRepository.getHistory();
      if (history.isEmpty) {
        emit(const HistoryLoaded([]));
      } else {
        emit(HistoryLoaded(history));
      }
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }
}
