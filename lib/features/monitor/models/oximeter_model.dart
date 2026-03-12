import '../../../core/constants/firebase_constants.dart';

class OximeterModel {
  final int spo2;
  final int heartRate;

  OximeterModel({required this.spo2, required this.heartRate});

  /// Expected payload: {"spo2": 95, "hr": 60}
  factory OximeterModel.fromJson(Map<String, dynamic> json) {
    return OximeterModel(
      spo2: (json[FirebaseConstants.keySpo2] as num?)?.toInt() ?? 0,
      heartRate: (json[FirebaseConstants.keyHr] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        FirebaseConstants.keySpo2: spo2,
        FirebaseConstants.keyHr: heartRate,
      };
}
