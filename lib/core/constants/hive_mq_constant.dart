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
  static const String kTopicAppStatus = 'CSBPM/appStatus';
  static const String kTopicCommand = 'CSBPM/command';

  // ── Subscribe Topics (string + QoS paired) ────────────────────────────────
  /// Final Blood Pressure reading.
  /// Uses QoS 1 (At Least Once) to guarantee delivery of critical health data.
  static const topicBP = MqttTopicConfig(kTopicBP, MqttQos.atLeastOnce);

  /// Live Blood Pressure waveform.
  /// Uses QoS 0 (At Most Once) for high-frequency data where speed is prioritized over reliability.
  static const topicBPLive = MqttTopicConfig(kTopicBPLive, MqttQos.atMostOnce);

  /// Real-time ECG signal data.
  /// Uses QoS 0 (At Most Once) to minimize latency for continuous waveform streaming.
  static const topicEcg = MqttTopicConfig(kTopicEcg, MqttQos.atMostOnce);

  /// Pulse Oximeter readings (SpO2 and Heart Rate).
  /// Uses QoS 1 (At Least Once) to ensure these vitals are accurately received.
  static const topicOximeter = MqttTopicConfig(
    kTopicOximeter,
    MqttQos.atLeastOnce,
  );

  /// App Heartbeat & Availability status.
  /// Uses QoS 1 (At Least Once) with Retention and LWT (Last Will and Testament).
  /// Publishes "appOnline" on connect and "appOffline" automatically via broker on crash/lost connection.
  static const topicAppStatus = MqttTopicConfig(
    kTopicAppStatus,
    MqttQos.atLeastOnce,
  );

  // ── Publish Topics ────────────────────────────────────────────────────────
  /// Remote control commands sent from the app to the IoT device.
  /// Uses QoS 1 (At Least Once) to ensure the device reliably receives instructions (e.g., 'start').
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
    topicAppStatus,
  ];
}
