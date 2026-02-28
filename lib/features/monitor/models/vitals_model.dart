import 'package:equatable/equatable.dart';

class VitalsModel extends Equatable {
  final List<double> ecg;
  final int spo2;
  final int heartRate;
  final int systolicBP;
  final int diastolicBP;
  final DateTime timestamp;

  const VitalsModel({
    required this.ecg,
    required this.spo2,
    required this.heartRate,
    required this.systolicBP,
    required this.diastolicBP,
    required this.timestamp,
  });

  factory VitalsModel.fromJson(Map<String, dynamic> json) {
    return VitalsModel(
      ecg:
          (json['ecg'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [],
      spo2: (json['spo2'] as num?)?.toInt() ?? 0,
      heartRate: (json['hr'] as num?)?.toInt() ?? 0,
      systolicBP: (json['sys'] as num?)?.toInt() ?? 0,
      diastolicBP: (json['dia'] as num?)?.toInt() ?? 0,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'].toString())
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ecg': ecg,
      'spo2': spo2,
      'hr': heartRate,
      'sys': systolicBP,
      'dia': diastolicBP,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // Fallback for initial state or empty data
  factory VitalsModel.empty() {
    return VitalsModel(
      ecg: const [],
      spo2: 0,
      heartRate: 0,
      systolicBP: 0,
      diastolicBP: 0,
      timestamp: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
    ecg,
    spo2,
    heartRate,
    systolicBP,
    diastolicBP,
    timestamp,
  ];
}
