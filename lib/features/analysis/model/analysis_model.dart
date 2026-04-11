import 'package:flutter/material.dart';

enum VitalsStatus {
  normal,
  warning,
  critical,
}

class VitalInterpretation {
  final String label;
  final VitalsStatus status;
  final Color color;
  final String description;

  const VitalInterpretation({
    required this.label,
    required this.status,
    required this.color,
    required this.description,
  });
}

class AnalysisResult {
  final VitalInterpretation bp;
  final VitalInterpretation estimatedBP;
  final VitalInterpretation hr;
  final VitalInterpretation spo2;

  const AnalysisResult({
    required this.bp,
    required this.estimatedBP,
    required this.hr,
    required this.spo2,
  });
}
