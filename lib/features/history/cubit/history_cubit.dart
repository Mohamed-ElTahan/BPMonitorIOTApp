import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/firebase_service.dart';
import 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final FirebaseService _firebaseService;

  HistoryCubit({required FirebaseService firebaseService})
    : _firebaseService = firebaseService,
      super(HistoryLoading());

  Future<void> loadHistory() async {
    emit(HistoryLoading());
    try {
      final data = await _firebaseService.getHistoryData();
      emit(HistoryLoaded(data));
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }
}
