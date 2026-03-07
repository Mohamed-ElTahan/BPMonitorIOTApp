import 'bp_model.dart';
import 'oximeter_model.dart';

class PatientMeasurementModel {
  final OximeterModel oximeter;
  final BPModel bP;
  final List<double> livePressure;
  final List<double> ecg;
  final List<double> ecgHistory;
  final String connectionStatus;
  final bool deviceOnline;
  final DateTime timestamp;

  const PatientMeasurementModel({
    required this.ecg,
    required this.oximeter,
    required this.bP,
    required this.livePressure,
    required this.timestamp,
    this.ecgHistory = const [],
    this.connectionStatus = '',
    this.deviceOnline = false,
  });

  PatientMeasurementModel copyWith({
    OximeterModel? oximeter,
    BPModel? bP,
    List<double>? livePressure,
    List<double>? ecg,
    List<double>? ecgHistory,
    String? connectionStatus,
    bool? deviceOnline,
    DateTime? timestamp,
  }) {
    return PatientMeasurementModel(
      oximeter: oximeter ?? this.oximeter,
      bP: bP ?? this.bP,
      livePressure: livePressure ?? this.livePressure,
      ecg: ecg ?? this.ecg,
      ecgHistory: ecgHistory ?? this.ecgHistory,
      connectionStatus: connectionStatus ?? this.connectionStatus,
      deviceOnline: deviceOnline ?? this.deviceOnline,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  // from json
  factory PatientMeasurementModel.fromJson(Map<String, dynamic> json) {
    List<double> ecgPoints = [];
    final ecgData = json['ecg'];
    if (ecgData is List) {
      ecgPoints = ecgData.map((e) => (e as num).toDouble()).toList();
    } else if (ecgData is num) {
      ecgPoints = [ecgData.toDouble()];
    }
    return PatientMeasurementModel(
      ecg: ecgPoints,
      oximeter: OximeterModel(
        spo2: (json['spo2'] as num?)?.toInt() ?? 0,
        heartRate: (json['hr'] as num?)?.toInt() ?? 0,
      ),
      bP: BPModel(
        systolic: (json['bp'] as num?)?.toDouble() ?? 0,
        diastolic: (json['bp'] as num?)?.toDouble() ?? 0,
      ),
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

  // convert to json
  Map<String, dynamic> toJson() {
    return {
      'ecg': ecg,
      'oximeter': oximeter,
      'bp': bP,
      'live_pressure': livePressure,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
