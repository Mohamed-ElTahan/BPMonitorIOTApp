// lib/core/services/firebase_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/monitor/models/vitals_model.dart';
import '../constants/app_constants.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveVitalsBatch(List<VitalsModel> vitalsBatch) async {
    if (vitalsBatch.isEmpty) return;

    try {
      final WriteBatch batch = _firestore.batch();

      final collectionRef = _firestore
          .collection(AppConstants.firestorePatientsCollection)
          .doc(AppConstants.defaultPatientId)
          .collection(AppConstants.firestoreSessionsSubcollection);

      for (var vitals in vitalsBatch) {
        final docRef = collectionRef.doc(); // Auto-generates ID
        batch.set(docRef, vitals.toJson());
      }

      await batch.commit();
      print(
        '=====> Successfully saved batch of ${vitalsBatch.length} readings to Firestore.',
      );
    } catch (e) {
      print('=====>Failed to save batch to Firestore: $e');
    }
  }

  Future<void> saveSingleVitals(VitalsModel vitals) async {
    try {
      final collectionRef = _firestore
          .collection(AppConstants.firestorePatientsCollection)
          .doc(AppConstants.defaultPatientId)
          .collection(AppConstants.firestoreSessionsSubcollection);

      await collectionRef.add(vitals.toJson());
      print('=====> Successfully saved single reading to Firestore.');
    } catch (e) {
      print('=====>Failed to save single reading to Firestore: $e');
    }
  }

  Future<List<VitalsModel>> getHistoryData() async {
    try {
      final collectionRef = _firestore
          .collection(AppConstants.firestorePatientsCollection)
          .doc(AppConstants.defaultPatientId)
          .collection(AppConstants.firestoreSessionsSubcollection);

      final querySnapshot = await collectionRef
          .orderBy('timestamp', descending: true)
          .limit(50)
          .get();

      print('=====> Success to get history data');
      return querySnapshot.docs
          .map((doc) => VitalsModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('=====> Failed to get history from Firestore: $e');
      return [];
    }
  }
}
