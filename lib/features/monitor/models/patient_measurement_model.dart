import 'bp_model.dart';
import 'oximeter_model.dart';

class PatientMeasurementModel {
  final BPModel bloodPressure;
  final BPModel estimatedBloodPressure;
  final OximeterModel oximeter;
  final List<double> livePressure;
  final List<double> ecg;

  const PatientMeasurementModel({
    required this.bloodPressure,
    required this.estimatedBloodPressure,
    required this.oximeter,
    required this.livePressure,
    required this.ecg,
  });

  PatientMeasurementModel copyWith({
    OximeterModel? oximeter,
    BPModel? bloodPressure,
    BPModel? estimatedBloodPressure,
    List<double>? livePressure,
    List<double>? ecg,
    double? creatinine,
    double? bun,
    double? alt,
    double? ast,
    double? glucose,
  }) {
    return PatientMeasurementModel(
      oximeter: oximeter ?? this.oximeter,
      bloodPressure: bloodPressure ?? this.bloodPressure,
      estimatedBloodPressure:
          estimatedBloodPressure ?? this.estimatedBloodPressure,
      livePressure: livePressure ?? this.livePressure,
      ecg: ecg ?? this.ecg,
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

    BPModel bp;
    if (json['bloodPressure'] is Map<String, dynamic>) {
      bp = BPModel.fromJson(json['bloodPressure']);
    } else {
      bp = BPModel(
        systolic: (json['bp'] as num?)?.toDouble() ?? 0.0,
        diastolic: (json['bp'] as num?)?.toDouble() ?? 0.0,
      );
    }

    BPModel estBp;
    if (json['estimatedBloodPressure'] is Map<String, dynamic>) {
      estBp = BPModel.fromJson(json['estimatedBloodPressure']);
    } else {
      estBp = BPModel(
        systolic: (json['estimated_bp'] as num?)?.toDouble() ?? 0.0,
        diastolic: (json['estimated_bp'] as num?)?.toDouble() ?? 0.0,
      );
    }

    OximeterModel oxi;
    if (json['oximeter'] is Map<String, dynamic>) {
      oxi = OximeterModel.fromJson(json['oximeter']);
    } else {
      oxi = OximeterModel(
        spo2: (json['spo2'] as num?)?.toInt() ?? 0,
        heartRate: (json['hr'] as num?)?.toInt() ?? 0,
      );
    }

    return PatientMeasurementModel(
      ecg: ecgPoints,
      oximeter: oxi,
      bloodPressure: bp,
      estimatedBloodPressure: estBp,
      livePressure:
          (json['live_pressure'] as List<num>?)
              ?.map((e) => e.toDouble())
              .toList() ??
          [],
    );
  }

  // convert to json
  Map<String, dynamic> toJson() {
    return {
      'ecg': ecg,
      'oximeter': oximeter.toJson(),
      'bloodPressure': bloodPressure.toJson(),
      'estimatedBloodPressure': estimatedBloodPressure.toJson(),
      'live_pressure': livePressure,
    };
  }
}
