import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bp_monitor_iot/features/history/model/patient_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'history';

  // Save patient measurement to Firestore
  Future<void> saveHistory(PatientModel history) async {
    try {
      await _firestore.collection(_collectionPath).add(history.toJson());
    } catch (e) {
      throw Exception('Failed to save history: $e');
    }
  }

  // get all patient history from firestore
  Future<List<PatientModel>> getAllHistory() async {
    try {
      final snapshot = await _firestore
          .collection(_collectionPath)
          .orderBy('timestamp', descending: true)
          .get();
      return snapshot.docs.map((doc) {
        return PatientModel.fromJson(doc.data());
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch history: $e');
    }
  }
}
