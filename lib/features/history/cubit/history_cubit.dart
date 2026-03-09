import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/data_source/firebase/firestore_service.dart';
import 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final FirestoreService firestoreService;

  HistoryCubit(this.firestoreService) : super(HistoryLoading());

  Future<void> loadHistory() async {
    try {
      emit(HistoryLoading());
      final history = await firestoreService.getAllHistory();
      if (history.isEmpty) {
        emit(const HistoryLoaded([]));
      } else {
        emit(HistoryLoaded(history));
      }
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }

  void listenToHistory() {
    firestoreService.getHistoryStream().listen((history) {
      emit(HistoryLoaded(history));
    });
  }
}
