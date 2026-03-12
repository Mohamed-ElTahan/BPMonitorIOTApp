import '../../../core/constants/firebase_constants.dart';

class BPModel {
  final double systolic;
  final double diastolic;

  BPModel({required this.systolic, required this.diastolic});

  /// Expected payload: {"systolic": 120, "diastolic": 80}
  factory BPModel.fromJson(Map<String, dynamic> json) {
    return BPModel(
      systolic: (json[FirebaseConstants.keySystolic] as num?)?.toDouble() ?? 0.0,
      diastolic:
          (json[FirebaseConstants.keyDiastolic] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
        FirebaseConstants.keySystolic: systolic,
        FirebaseConstants.keyDiastolic: diastolic,
      };
}
