class VitalsModel {
  final double ecgValue;
  final double spo2;
  final double heartRate;
  final double systolicBP;
  final double diastolicBP;

  const VitalsModel({
    required this.ecgValue,
    required this.spo2,
    required this.heartRate,
    required this.systolicBP,
    required this.diastolicBP,
  });

  factory VitalsModel.fromJson(Map<String, dynamic> json) {
    return VitalsModel(
      ecgValue: (json['ecg'] as num).toDouble(),
      spo2: (json['spo2'] as num).toDouble(),
      heartRate: (json['heart_rate'] as num).toDouble(),
      systolicBP: (json['systolic_bp'] as num).toDouble(),
      diastolicBP: (json['diastolic_bp'] as num).toDouble(),
    );
  }

  // Fallback for initial state or empty data
  factory VitalsModel.empty() {
    return const VitalsModel(
      ecgValue: 0.0,
      spo2: 0.0,
      heartRate: 0.0,
      systolicBP: 0.0,
      diastolicBP: 0.0,
    );
  }
}
