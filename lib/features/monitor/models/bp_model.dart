class BPModel {
  final double systolic;
  final double diastolic;

  BPModel({required this.systolic, required this.diastolic});

  /// Expected payload: {"systolic": 120, "diastolic": 80}
  factory BPModel.fromJson(Map<String, dynamic> json) {
    return BPModel(
      systolic: (json['systolic'] as num?)?.toDouble() ?? 0,
      diastolic: (json['diastolic'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'systolic': systolic,
    'diastolic': diastolic,
  };
}
