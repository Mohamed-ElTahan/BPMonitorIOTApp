class OximeterModel {
  final int spo2;
  final int heartRate;

  OximeterModel({required this.spo2, required this.heartRate});

  /// Expected payload: {"spo2": 95, "hr": 60}
  factory OximeterModel.fromJson(Map<String, dynamic> json) {
    return OximeterModel(
      spo2: (json['spo2'] as num?)?.toInt() ?? 0,
      heartRate: (json['hr'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {'spo2': spo2, 'hr': heartRate};
}
