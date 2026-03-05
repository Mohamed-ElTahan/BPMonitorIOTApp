import 'package:equatable/equatable.dart';

class VitalsModel extends Equatable {
  final List<double> ecg;
  final int spo2;
  final int heartRate;
  final double systolicBP;
  final double diastolicBP;
  final List<double> livePressure;
  final DateTime timestamp;

  const VitalsModel({
    required this.ecg,
    required this.spo2,
    required this.heartRate,
    required this.systolicBP,
    required this.diastolicBP,
    required this.livePressure,
    required this.timestamp,
  });

  factory VitalsModel.fromJson(Map<String, dynamic> json) {
    List<double> ecgPoints = [];
    final ecgData = json['ecg'];
    if (ecgData is List) {
      ecgPoints = ecgData.map((e) => (e as num).toDouble()).toList();
    } else if (ecgData is num) {
      ecgPoints = [ecgData.toDouble()];
    }

    return VitalsModel(
      ecg: ecgPoints,
      spo2: (json['spo2'] as num?)?.toInt() ?? 0,
      heartRate: (json['hr'] as num?)?.toInt() ?? 0,
      systolicBP: (json['sys'] as num?)?.toDouble() ?? 0.0,
      diastolicBP: (json['dia'] as num?)?.toDouble() ?? 0.0,
      livePressure:
          (json['live_pressure'] as List<num>?)
              ?.map((e) => e.toDouble())
              .toList() ??
          [],
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
      'live_pressure': livePressure,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // Fallback for initial state or empty data
  factory VitalsModel.empty() {
    return VitalsModel(
      ecg: const [],
      spo2: 0,
      heartRate: 0,
      systolicBP: 0.0,
      diastolicBP: 0.0,
      livePressure: const [],
      timestamp: DateTime.now(),
    );
  }

  VitalsModel copyWith({
    List<double>? ecg,
    int? spo2,
    int? heartRate,
    double? systolicBP,
    double? diastolicBP,
    List<double>? livePressure,
    DateTime? timestamp,
  }) {
    return VitalsModel(
      ecg: ecg ?? this.ecg,
      spo2: spo2 ?? this.spo2,
      heartRate: heartRate ?? this.heartRate,
      systolicBP: systolicBP ?? this.systolicBP,
      diastolicBP: diastolicBP ?? this.diastolicBP,
      livePressure: livePressure ?? this.livePressure,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  List<Object?> get props => [
    ecg,
    spo2,
    heartRate,
    systolicBP,
    diastolicBP,
    livePressure,
    timestamp,
  ];
}
