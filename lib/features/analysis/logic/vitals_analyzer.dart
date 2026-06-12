import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../model/analysis_model.dart';

class VitalsAnalyzer {
  static AnalysisResult analyze(
    double systolic,
    double diastolic,
    double estimatedSystolic,
    double estimatedDiastolic,
    int heartRate,
    int spo2,
  ) {
    return AnalysisResult(
      bp: interpretBP(systolic, diastolic),
      estimatedBP: interpretEstimatedBP(estimatedSystolic, estimatedDiastolic),
      hr: interpretHR(heartRate),
      spo2: interpretSpo2(spo2),
    );
  }

  static VitalInterpretation interpretEstimatedBP(
    double systolic,
    double diastolic,
  ) {
    if (systolic == 0 || diastolic == 0) {
      return const VitalInterpretation(
        label: 'Est. N/A',
        status: VitalsStatus.normal,
        color: Colors.grey,
        description: 'No estimated blood pressure reading detected.',
      );
    }
    // We can reuse the same interpretation logic but perhaps add a note it's estimated
    final base = interpretBP(systolic, diastolic);
    return VitalInterpretation(
      label: 'Est. ${base.label}',
      status: base.status,
      color: base.color,
      description: 'Estimated: ${base.description}',
    );
  }

  static VitalInterpretation interpretBP(double systolic, double diastolic) {
    if (systolic == 0 || diastolic == 0) {
      return const VitalInterpretation(
        label: 'N/A',
        status: VitalsStatus.normal,
        color: Colors.grey,
        description: 'No blood pressure reading detected.',
      );
    }
    if (systolic < 120 && diastolic < 80) {
      return const VitalInterpretation(
        label: 'Normal',
        status: VitalsStatus.normal,
        color: AppColors.ecgGreen,
        description: 'Systolic and diastolic pressures are within optimal limits.',
      );
    } else if (systolic < 130 && diastolic < 80) {
      return const VitalInterpretation(
        label: 'Elevated',
        status: VitalsStatus.warning,
        color: AppColors.bpAmber,
        description:
            'Pressure is elevated. Lifestyle monitoring and routine checks advised.',
      );
    } else if (systolic < 140 || diastolic < 90) {
      return VitalInterpretation(
        label: 'Hypertension Stage 1',
        status: VitalsStatus.warning,
        color: Colors.orange.shade700,
        description: 'Stage 1 hypertension. Medical consultation is recommended.',
      );
    } else if (systolic < 180 || diastolic < 120) {
      return const VitalInterpretation(
        label: 'Hypertension Stage 2',
        status: VitalsStatus.critical,
        color: AppColors.heartRateRed,
        description:
            'Stage 2 hypertension. Consistent monitoring and medical advice required.',
      );
    } else {
      return const VitalInterpretation(
        label: 'Hypertensive Crisis',
        status: VitalsStatus.critical,
        color: Colors.redAccent,
        description: 'Hypertensive crisis. Seek immediate emergency medical care.',
      );
    }
  }

  static VitalInterpretation interpretHR(int heartRate) {
    if (heartRate == 0) {
      return const VitalInterpretation(
        label: 'N/A',
        status: VitalsStatus.normal,
        color: Colors.grey,
        description: 'No heart rate reading detected.',
      );
    }
    if (heartRate < 60) {
      return const VitalInterpretation(
        label: 'Bradycardia',
        status: VitalsStatus.warning,
        color: Colors.blue,
        description: 'Bradycardia. Heart rate is below normal resting range.',
      );
    } else if (heartRate <= 100) {
      return const VitalInterpretation(
        label: 'Normal',
        status: VitalsStatus.normal,
        color: AppColors.ecgGreen,
        description: 'Normal resting heart rate.',
      );
    } else {
      return const VitalInterpretation(
        label: 'Tachycardia',
        status: VitalsStatus.warning,
        color: AppColors.heartRateRed,
        description: 'Tachycardia. Heart rate is above normal resting range.',
      );
    }
  }

  static VitalInterpretation interpretSpo2(int spo2) {
    if (spo2 == 0) {
      return const VitalInterpretation(
        label: 'N/A',
        status: VitalsStatus.normal,
        color: Colors.grey,
        description: 'No oxygen saturation reading detected.',
      );
    }
    if (spo2 >= 95) {
      return const VitalInterpretation(
        label: 'Normal',
        status: VitalsStatus.normal,
        color: AppColors.ecgGreen,
        description: 'Optimal blood oxygen saturation level.',
      );
    } else if (spo2 >= 90) {
      return const VitalInterpretation(
        label: 'Low (Hypoxia)',
        status: VitalsStatus.warning,
        color: AppColors.bpAmber,
        description: 'Mild hypoxia. Oxygen saturation is below normal.',
      );
    } else {
      return const VitalInterpretation(
        label: 'Critical',
        status: VitalsStatus.critical,
        color: AppColors.heartRateRed,
        description:
            'Severe hypoxia. Immediate medical intervention required.',
      );
    }
  }
}
