import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../features/history/model/history_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'history';

  Future<void> saveHistory(HistoryModel history) async {
    try {
      await _firestore.collection(_collectionPath).add(history.toJson());
    } catch (e) {
      throw Exception('Failed to save history: $e');
    }
  }

  Stream<List<HistoryModel>> getHistoryStream() {
    return _firestore
        .collection(_collectionPath)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return HistoryModel.fromJson(doc.data());
          }).toList();
        });
  }

  Future<List<HistoryModel>> getAllHistory() async {
    try {
      final snapshot = await _firestore
          .collection(_collectionPath)
          .orderBy('timestamp', descending: true)
          .get();
      return snapshot.docs.map((doc) {
        return HistoryModel.fromJson(doc.data());
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch history: $e');
    }
  }
}
