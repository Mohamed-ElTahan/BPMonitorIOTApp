import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bp_monitor_iot/features/history/model/patient_model.dart';
import '../../constants/firebase_constants.dart';

class FirestoreDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = FirebaseConstants.collectionHistory;

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
          .orderBy(FirebaseConstants.keyTimestamp, descending: true)
          .get();
      return snapshot.docs.map((doc) {
        return PatientModel.fromJson(doc.data(), id: doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch history: $e');
    }
  }

  // delete patient measurement record from Firestore
  Future<void> deletePatientRecord(String id) async {
    try {
      await _firestore.collection(_collectionPath).doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete patient record: $e');
    }
  }
}
