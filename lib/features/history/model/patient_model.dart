import 'package:cloud_firestore/cloud_firestore.dart';
import '../../monitor/models/bp_model.dart';
import '../../monitor/models/oximeter_model.dart';
import '../../monitor/models/patient_measurement_model.dart';
import '../../../core/constants/firebase_constants.dart';

class PatientModel extends PatientMeasurementModel {
  final String? id;
  final String name;
  final String gender;
  final int age;
  final DateTime timestamp;

  const PatientModel({
    this.id,
    required this.name,
    required this.gender,
    required this.age,

    required super.oximeter,
    required super.bloodPressure,
    required super.estimatedBloodPressure,
    required super.livePressure,
    required super.ecg,
    required this.timestamp,
  });

  // from Json
  factory PatientModel.fromJson(Map<String, dynamic> json, {String? id}) {
    // Parse blood pressure for backward compatibility
    BPModel bp;
    if (json[FirebaseConstants.keyBloodPressure] is String) {
      final parts = (json[FirebaseConstants.keyBloodPressure] as String).split(
        '/',
      );
      bp = BPModel(
        systolic: parts.isNotEmpty ? double.tryParse(parts[0]) ?? 0.0 : 0.0,
        diastolic: parts.length > 1 ? double.tryParse(parts[1]) ?? 0.0 : 0.0,
      );
    } else if (json[FirebaseConstants.keyBloodPressure]
        is Map<String, dynamic>) {
      bp = BPModel.fromJson(json[FirebaseConstants.keyBloodPressure]);
    } else {
      bp = BPModel(systolic: 0.0, diastolic: 0.0);
    }

    // Parse estimated blood pressure
    BPModel estBp;
    if (json[FirebaseConstants.keyEstimatedBloodPressure]
        is Map<String, dynamic>) {
      estBp = BPModel.fromJson(json[FirebaseConstants.keyEstimatedBloodPressure]);
    } else {
      estBp = BPModel(systolic: 0.0, diastolic: 0.0);
    }

    // Parse oximeter for backward compatibility
    OximeterModel oxi;
    if (json[FirebaseConstants.keyOximeter] is Map<String, dynamic>) {
      oxi = OximeterModel.fromJson(json[FirebaseConstants.keyOximeter]);
    } else {
      oxi = OximeterModel(
        spo2: (json[FirebaseConstants.keySpo2] as num?)?.toInt() ?? 0,
        heartRate: (json[FirebaseConstants.keyHeartRate] as num?)?.toInt() ?? 0,
      );
    }

    // Parse ECG
    List<double> ecgPoints = [];
    final ecgData = json[FirebaseConstants.keyEcg];
    if (ecgData is List) {
      ecgPoints = ecgData.map((e) => (e as num).toDouble()).toList();
    } else if (ecgData is num) {
      ecgPoints = [ecgData.toDouble()];
    }

    return PatientModel(
      id: id,
      name: json[FirebaseConstants.keyName] ?? "Unknown",
      gender: json[FirebaseConstants.keyGender] ?? "Unknown",
      age: json[FirebaseConstants.keyAge] ?? 0,
      timestamp: json[FirebaseConstants.keyTimestamp] is Timestamp
          ? (json[FirebaseConstants.keyTimestamp] as Timestamp).toDate()
          : DateTime.tryParse(
                  json[FirebaseConstants.keyTimestamp].toString(),
                ) ??
                DateTime.now(),
      bloodPressure: bp,
      estimatedBloodPressure: estBp,
      oximeter: oxi,
      livePressure: List<double>.from(
        json[FirebaseConstants.keyLivePressure] ?? [],
      ),
      ecg: ecgPoints,
    );
  }

  // to Json
  @override
  Map<String, dynamic> toJson() {
    return {
      FirebaseConstants.keyName: name,
      FirebaseConstants.keyGender: gender,
      FirebaseConstants.keyAge: age,
      FirebaseConstants.keyBloodPressure: bloodPressure.toJson(),
      FirebaseConstants.keyEstimatedBloodPressure: estimatedBloodPressure.toJson(),
      FirebaseConstants.keyOximeter: oximeter.toJson(),
      FirebaseConstants.keyLivePressure: livePressure,
      FirebaseConstants.keyEcg: ecg,
      FirebaseConstants.keyTimestamp: timestamp,
    };
  }
}
