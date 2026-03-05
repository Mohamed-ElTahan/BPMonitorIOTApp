import 'package:flutter_bloc/flutter_bloc.dart';
import 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit() : super(HistoryLoading());

  Future<void> loadHistory() async {
    emit(HistoryLoading());
    await Future.delayed(const Duration(seconds: 2));
    emit(HistoryLoaded(const []));
  }
}
