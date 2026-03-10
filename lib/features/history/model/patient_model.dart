import 'package:cloud_firestore/cloud_firestore.dart';

class PatientModel {
  final String name;
  final String sex;
  final int age;
  final String bloodPressure;
  final List<double> livePressure;
  final int heartRate;
  final int spo2;
  final List<double> ecg;
  final DateTime timestamp;

  const PatientModel({
    required this.name,
    required this.sex,
    required this.age,
    required this.bloodPressure,
    required this.livePressure,
    required this.heartRate,
    required this.spo2,
    required this.ecg,
    required this.timestamp,
  });

  // from Json
  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      name: json['name'] ?? "Unknown",
      sex: json['sex'] ?? "Unknown",
      age: json['age'] ?? 0,
      bloodPressure: json['bloodPressure'] ?? "0/0",
      livePressure: List<double>.from(json['livePressure'] ?? []),
      heartRate: json['heartRate'] ?? 0,
      spo2: json['spo2'] ?? 0,
      ecg: List<double>.from(json['ecg'] ?? []),
      timestamp: json['timestamp'] is Timestamp
          ? (json['timestamp'] as Timestamp).toDate()
          : DateTime.tryParse(json['timestamp'].toString()) ?? DateTime.now(),
    );
  }

  // to Json
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'sex': sex,
      'age': age,
      'bloodPressure': bloodPressure,
      'livePressure': livePressure,
      'heartRate': heartRate,
      'spo2': spo2,
      'ecg': ecg,
      'timestamp': timestamp,
    };
  }
}
