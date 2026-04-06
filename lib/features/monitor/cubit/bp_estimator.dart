import '../models/bp_model.dart';

class BpEstimator {
  static BPModel estimate(int hr, int spo2) {
    // validation
    if (hr == 0 || spo2 == 0) {
      return BPModel(systolic: 0, diastolic: 0);
    }

    // Basic heuristic for estimating BP based on HR and SpO2.
    // This is a placeholder logic for demonstration.
    double baseSys = 120.0;
    double baseDia = 80.0;

    // Heart rate factor: HR over 70 slightly increases BP.
    double hrFactorSys = (hr > 70) ? (hr - 70) * 0.5 : 0;
    double hrFactorDia = (hr > 70) ? (hr - 70) * 0.3 : 0;

    // SpO2 factor: Lower SpO2 (< 98) might slightly increase BP due to compensation.
    double spo2FactorSys = (spo2 < 98 && spo2 > 0) ? (98 - spo2) * 1.5 : 0;
    double spo2FactorDia = (spo2 < 98 && spo2 > 0) ? (98 - spo2) * 1.0 : 0;

    double sys = baseSys + hrFactorSys + spo2FactorSys;
    double dia = baseDia + hrFactorDia + spo2FactorDia;

    return BPModel(systolic: sys, diastolic: dia);
  }
}
