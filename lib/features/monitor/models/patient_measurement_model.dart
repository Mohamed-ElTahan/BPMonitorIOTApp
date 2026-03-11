import 'bp_model.dart';
import 'oximeter_model.dart';

class PatientMeasurementModel {
  final BPModel bloodPressure;
  final OximeterModel oximeter;
  final List<double> livePressure;
  final List<double> ecg;

  const PatientMeasurementModel({
    required this.bloodPressure,
    required this.oximeter,
    required this.livePressure,
    required this.ecg,
  });

  PatientMeasurementModel copyWith({
    OximeterModel? oximeter,
    BPModel? bloodPressure,
    List<double>? livePressure,
    List<double>? ecg,
  }) {
    return PatientMeasurementModel(
      oximeter: oximeter ?? this.oximeter,
      bloodPressure: bloodPressure ?? this.bloodPressure,
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
    return PatientMeasurementModel(
      ecg: ecgPoints,
      oximeter: OximeterModel(
        spo2: (json['spo2'] as num?)?.toInt() ?? 0,
        heartRate: (json['hr'] as num?)?.toInt() ?? 0,
      ),
      bloodPressure: BPModel(
        systolic: (json['bp'] as num?)?.toDouble() ?? 0.0,
        diastolic: (json['bp'] as num?)?.toDouble() ?? 0.0,
      ),
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
      'oximeter': oximeter,
      'bloodPressure': bloodPressure,
      'live_pressure': livePressure,
    };
  }
}
