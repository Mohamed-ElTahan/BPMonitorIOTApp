import 'package:mqtt_client/mqtt_client.dart';

// ─── Topic Config Model ────────────────────────────────────────────────────
class MqttTopicConfig {
  final String topic;
  final MqttQos qos;

  const MqttTopicConfig(this.topic, this.qos);

  @override
  String toString() => topic;
}

// ─── App Constants ─────────────────────────────────────────────────────────
class HiveMqConstant {
  // MQTT Broker
  static const String mqttBrokerUrl =
      'baecf45d3be147d89925b349a789b8f5.s1.eu.hivemq.cloud';
  static const int mqttPort = 8883;
  static const String mqttClientId = 'bp_monitor_app';
  static const String mqttUsername = 'CSBPM';
  static const String mqttPassword = 'comm-SBPM1';

  // ── Topic Strings  ─────────────────────────
  static const String kTopicBP = 'CSBPM/bp';
  static const String kTopicBPLive = 'CSBPM/bpLive';
  static const String kTopicEcg = 'CSBPM/ecg';
  static const String kTopicOximeter = 'CSBPM/oximeter';
  static const String kTopicStatus = 'CSBPM/status';
  static const String kTopicCommand = 'CSBPM/command';

  // ── Subscribe Topics (string + QoS paired) ────────────────────────────────
  /// Final BP reading — guaranteed delivery (QoS 1).
  static const topicBP = MqttTopicConfig(kTopicBP, MqttQos.atLeastOnce);

  /// Live BP waveform — high frequency, best-effort (QoS 0).
  static const topicBPLive = MqttTopicConfig(kTopicBPLive, MqttQos.atMostOnce);

  /// ECG signal — high frequency, best-effort (QoS 0).
  static const topicEcg = MqttTopicConfig(kTopicEcg, MqttQos.atMostOnce);

  /// Oximeter reading — guaranteed delivery (QoS 1).
  static const topicOximeter = MqttTopicConfig(
    kTopicOximeter,
    MqttQos.atLeastOnce,
  );

  /// Device status — guaranteed delivery + retained (QoS 1).
  static const topicStatus = MqttTopicConfig(kTopicStatus, MqttQos.atLeastOnce);

  // ── Publish Topics ────────────────────────────────────────────────────────
  /// Command to device — guaranteed delivery (QoS 1).
  static const topicCommand = MqttTopicConfig(
    kTopicCommand,
    MqttQos.atLeastOnce,
  );

  // ── All subscribe topics in one list ─────────────────────────────────────
  static const List<MqttTopicConfig> subscribeTopics = [
    topicBP,
    topicBPLive,
    topicEcg,
    topicOximeter,
    topicStatus,
  ];
}
