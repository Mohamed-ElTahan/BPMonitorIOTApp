import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../model/analysis_model.dart';

class VitalsAnalyzer {
  static AnalysisResult analyze(
    double systolic,
    double diastolic,
    int heartRate,
    int spo2,
  ) {
    return AnalysisResult(
      bp: interpretBP(systolic, diastolic),
      hr: interpretHR(heartRate),
      spo2: interpretSpo2(spo2),
    );
  }

  static VitalInterpretation interpretBP(double systolic, double diastolic) {
    if (systolic < 120 && diastolic < 80) {
      return const VitalInterpretation(
        label: 'Normal',
        status: VitalsStatus.normal,
        color: AppColors.ecgGreen,
        description: 'Your blood pressure is within the healthy range.',
      );
    } else if (systolic < 130 && diastolic < 80) {
      return const VitalInterpretation(
        label: 'Elevated',
        status: VitalsStatus.warning,
        color: AppColors.bpAmber,
        description:
            'Your blood pressure is slightly high. Lifestyle changes may be needed.',
      );
    } else if (systolic < 140 || diastolic < 90) {
      return VitalInterpretation(
        label: 'Hypertension Stage 1',
        status: VitalsStatus.warning,
        color: Colors.orange.shade700,
        description: 'You have Stage 1 hypertension. Consult your doctor.',
      );
    } else if (systolic < 180 || diastolic < 120) {
      return const VitalInterpretation(
        label: 'Hypertension Stage 2',
        status: VitalsStatus.critical,
        color: AppColors.heartRateRed,
        description:
            'You have Stage 2 hypertension. Frequent monitoring is advised.',
      );
    } else {
      return const VitalInterpretation(
        label: 'Hypertensive Crisis',
        status: VitalsStatus.critical,
        color: Colors.redAccent,
        description: 'Urgent medical attention is required!',
      );
    }
  }

  static VitalInterpretation interpretHR(int heartRate) {
    if (heartRate < 60) {
      return const VitalInterpretation(
        label: 'Bradycardia',
        status: VitalsStatus.warning,
        color: Colors.blue,
        description: 'Your heart rate is lower than normal.',
      );
    } else if (heartRate <= 100) {
      return const VitalInterpretation(
        label: 'Normal',
        status: VitalsStatus.normal,
        color: AppColors.ecgGreen,
        description: 'Your heart rate is within the healthy resting range.',
      );
    } else {
      return const VitalInterpretation(
        label: 'Tachycardia',
        status: VitalsStatus.warning,
        color: AppColors.heartRateRed,
        description: 'Your heart rate is higher than normal.',
      );
    }
  }

  static VitalInterpretation interpretSpo2(int spo2) {
    if (spo2 >= 95) {
      return const VitalInterpretation(
        label: 'Normal',
        status: VitalsStatus.normal,
        color: AppColors.ecgGreen,
        description: 'Your blood oxygen level is healthy.',
      );
    } else if (spo2 >= 90) {
      return const VitalInterpretation(
        label: 'Low (Hypoxia)',
        status: VitalsStatus.warning,
        color: AppColors.bpAmber,
        description: 'Your blood oxygen level is slightly low.',
      );
    } else {
      return const VitalInterpretation(
        label: 'Critical',
        status: VitalsStatus.critical,
        color: AppColors.heartRateRed,
        description:
            'Your oxygen levels are critically low. Seek medical help!',
      );
    }
  }
}
