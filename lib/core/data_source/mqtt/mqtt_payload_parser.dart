import 'dart:convert';
import 'package:flutter/foundation.dart' show kDebugMode;
import '../../../features/monitor/models/bp_model.dart';
import '../../../features/monitor/models/oximeter_model.dart';
import '../../constants/hive_mq_constant.dart';

// Converts raw MQTT string payloads into typed Dart objects.
class MqttPayloadParser {
  static dynamic parse(String topic, String payload) {
    try {
      switch (topic) {
        case HiveMqConstant.kTopicBP:
          return BPModel.fromJson(jsonDecode(payload) as Map<String, dynamic>);
        case HiveMqConstant.kTopicBPLive:
          final decoded = jsonDecode(payload);
          if (decoded is List) {
            return decoded.map((e) => (e as num).toDouble()).toList();
          }
          return [(decoded as num).toDouble()];
        case HiveMqConstant.kTopicEcg:
          final decoded = jsonDecode(payload);
          if (decoded is List) {
            return decoded.map((e) => (e as num).toDouble()).toList();
          }
          return [(decoded as num).toDouble()];
        case HiveMqConstant.kTopicOximeter:
          return OximeterModel.fromJson(
            jsonDecode(payload) as Map<String, dynamic>,
          );
        case HiveMqConstant.kTopicAppStatus:
          return payload == 'online';
      }
    } catch (e) {
      if (kDebugMode) print('⚠️ Parse error on $topic: $e');
    }
    return null;
  }
}
