import 'package:bp_monitor_iot/core/data_source/firebase/firestore_data_source.dart';
import 'package:bp_monitor_iot/features/history/model/patient_model.dart';

class HistoryRepository {
  final FirestoreDataSource _firestoreDataSource;

  HistoryRepository(this._firestoreDataSource);

  Future<List<PatientModel>> getHistory() async {
    return await _firestoreDataSource.getAllHistory();
  }

  Future<void> deletePatientRecord(String id) async {
    return await _firestoreDataSource.deletePatientRecord(id);
  }
}
