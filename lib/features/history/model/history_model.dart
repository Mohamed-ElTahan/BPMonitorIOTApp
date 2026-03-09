import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryModel {
  final String bloodPressure; // 120/80
  final List<int> livePressure;
  final int heartRate;
  final int spo2;
  final List<double> ecg;
  final DateTime timestamp;

  const HistoryModel({
    required this.bloodPressure,
    required this.livePressure,
    required this.heartRate,
    required this.spo2,
    required this.ecg,
    required this.timestamp,
  });

  // from Json
  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      bloodPressure: json['bloodPressure'] ?? "0/0",
      livePressure: List<int>.from(json['livePressure'] ?? []),
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
      'bloodPressure': bloodPressure,
      'livePressure': livePressure,
      'heartRate': heartRate,
      'spo2': spo2,
      'ecg': ecg,
      'timestamp': timestamp,
    };
  }
}
