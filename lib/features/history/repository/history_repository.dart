import 'package:bp_monitor_iot/core/data_source/firebase/firestore_service.dart';
import 'package:bp_monitor_iot/features/history/model/patient_model.dart';

class HistoryRepository {
  final FirestoreService _firestoreService;

  HistoryRepository(this._firestoreService);

  Future<List<PatientModel>> getHistory() async {
    return await _firestoreService.getAllHistory();
  }
}
