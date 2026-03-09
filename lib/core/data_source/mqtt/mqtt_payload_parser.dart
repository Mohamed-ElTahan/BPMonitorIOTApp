import 'dart:convert';
import 'package:flutter/foundation.dart' show kDebugMode;
import '../../../features/monitor/models/oximeter_model.dart';
import '../../../features/monitor/models/patient_measurement_model.dart';
import '../../constants/app_constants.dart';

// Converts raw MQTT string payloads into typed Dart objects.
class MqttPayloadParser {
  static dynamic parse(String topic, String payload) {
    try {
      switch (topic) {
        case AppConstants.topicBP:
          return PatientMeasurementModel.fromJson(jsonDecode(payload)).bP;

        case AppConstants.topicBPLive:
          return int.tryParse(payload);

        case AppConstants.topicEcg:
          return double.tryParse(payload);

        case AppConstants.topicOximeter:
          final data = jsonDecode(payload) as Map<String, dynamic>;
          return OximeterModel(
            spo2: (data['spo2'] as num?)?.toInt() ?? 0,
            heartRate: (data['hr'] as num?)?.toInt() ?? 0,
          );

        case AppConstants.topicStatus:
          return payload == 'online';

        default:
          return null;
      }
    } catch (e) {
      if (kDebugMode) print('⚠️ Parse error on $topic: $e');
      return null;
    }
  }
}
