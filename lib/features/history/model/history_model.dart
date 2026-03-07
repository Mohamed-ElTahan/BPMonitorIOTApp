class HistoryModel {
  final int systolic;
  final int diastolic;
  final List<int> livePressure;
  final int heartRate;
  final int spo2;
  final List<double> ecg;
  final DateTime timestamp;

  const HistoryModel({
    required this.systolic,
    required this.diastolic,
    required this.livePressure,
    required this.heartRate,
    required this.spo2,
    required this.ecg,
    required this.timestamp,
  });
}
