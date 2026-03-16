import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../model/analysis_model.dart';

class VitalsAnalyzer {
  static AnalysisResult analyze(
    double systolic,
    double diastolic,
    int heartRate,
    int spo2, {
    double? creatinine,
    double? bun,
    double? alt,
    double? ast,
    double? glucose,
  }) {
    return AnalysisResult(
      bp: interpretBP(systolic, diastolic),
      hr: interpretHR(heartRate),
      spo2: interpretSpo2(spo2),
      kidney: interpretKidney(creatinine, bun),
      liver: interpretLiver(alt, ast),
      glucose: interpretGlucose(glucose),
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
  static VitalInterpretation? interpretKidney(double? creatinine, double? bun) {
    if (creatinine == null && bun == null) return null;

    final c = creatinine ?? 0.0;
    final b = bun ?? 0.0;

    if (c > 2.0 || b > 40.0) {
      return const VitalInterpretation(
        label: 'Critical Impairment',
        status: VitalsStatus.critical,
        color: AppColors.heartRateRed,
        description:
            'Significantly elevated markers. Seek immediate specialist consultation.',
      );
    } else if (c > 1.3 || b > 20.0) {
      return const VitalInterpretation(
        label: 'Kidney Stress',
        status: VitalsStatus.warning,
        color: Colors.orange,
        description:
            'Markers are above normal. High protein, dehydration, or renal stress possible.',
      );
    } else {
      return const VitalInterpretation(
        label: 'Optimal',
        status: VitalsStatus.normal,
        color: AppColors.ecgGreen,
        description: 'Your kidney function markers are within healthy limits.',
      );
    }
  }

  static VitalInterpretation? interpretLiver(double? alt, double? ast) {
    if (alt == null && ast == null) return null;

    final l = alt ?? 0.0;
    final s = ast ?? 0.0;

    if (l > 150.0 || s > 150.0) {
      return const VitalInterpretation(
        label: 'Acute Injury',
        status: VitalsStatus.critical,
        color: AppColors.heartRateRed,
        description:
            'Severe enzyme elevation detected. Immediate medical review required.',
      );
    } else if (l > 55.0 || s > 48.0) {
      return const VitalInterpretation(
        label: 'Liver Stress',
        status: VitalsStatus.warning,
        color: Colors.orange,
        description:
            'Elevated enzymes may indicate inflammation or fatty liver changes.',
      );
    } else {
      return const VitalInterpretation(
        label: 'Healthy',
        status: VitalsStatus.normal,
        color: AppColors.ecgGreen,
        description:
            'Your liver enzyme levels are currently within normal range.',
      );
    }
  }

  static VitalInterpretation? interpretGlucose(double? glucose) {
    if (glucose == null) return null;

    if (glucose < 70.0) {
      return const VitalInterpretation(
        label: 'Hypoglycemia',
        status: VitalsStatus.warning,
        color: Colors.blue,
        description:
            'Low blood sugar. Consume fast-acting glucose and monitor.',
      );
    } else if (glucose <= 100.0) {
      return const VitalInterpretation(
        label: 'Normal',
        status: VitalsStatus.normal,
        color: AppColors.ecgGreen,
        description: 'Your fasting blood sugar is in the healthy range.',
      );
    } else if (glucose <= 125.0) {
      return const VitalInterpretation(
        label: 'High (Prediabetes)',
        status: VitalsStatus.warning,
        color: Colors.orange,
        description:
            'Elevated glucose. Lifestyle modifications and monitoring recommended.',
      );
    } else {
      return const VitalInterpretation(
        label: 'Diabetes Range',
        status: VitalsStatus.critical,
        color: AppColors.heartRateRed,
        description:
            'Critical elevation. Consult a physician for diagnostic testing.',
      );
    }
  }
}
