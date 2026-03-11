import 'dart:async';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:mqtt_client/mqtt_client.dart';
import '../../constants/hive_mq_constant.dart';
import '../../../features/monitor/models/bp_model.dart';
import '../../../features/monitor/models/oximeter_model.dart';
import 'mqtt_client_manager.dart';
import 'mqtt_payload_parser.dart';

// High-level MQTT interface: subscribes to all topics and exposes typed streams.
class MqttDataSource {
  // ─── Internal ─────────────────────────────────────────────────────────────
  final MqttClientManager _manager;
  StreamSubscription? _messageSubscription;
  StreamSubscription? _connectionSubscription;

  /// Tracks which topics have already been subscribed to avoid duplicate
  /// SUB packets being sent to the broker on reconnect.
  final _subscribedTopics = <String>{};

  // Expose the raw client for callers that need direct access (e.g. HomeCubit).
  MqttClient get client => _manager.client;

  bool get isConnected => _manager.isConnected;

  // ─── Output Streams ───────────────────────────────────────────────────────
  final _bpController = StreamController<BPModel>.broadcast();
  final _bpLiveController = StreamController<double>.broadcast();
  final _ecgController = StreamController<double>.broadcast();
  final _oximeterController = StreamController<OximeterModel>.broadcast();
  final _deviceStatusController = StreamController<bool>.broadcast();
  final _connectionController = StreamController<bool>.broadcast();

  Stream<BPModel> get bpStream => _bpController.stream;
  Stream<double> get bpLiveStream => _bpLiveController.stream;
  Stream<double> get ecgStream => _ecgController.stream;
  Stream<OximeterModel> get oximeterStream => _oximeterController.stream;
  Stream<bool> get deviceStatusStream => _deviceStatusController.stream;
  Stream<bool> get connectionStream => _connectionController.stream;

  // ─── Constructor ──────────────────────────────────────────────────────────
  MqttDataSource()
    : _manager = MqttClientManager(
        broker: HiveMqConstant.mqttBrokerUrl,
        port: HiveMqConstant.mqttPort,
        username: HiveMqConstant.mqttUsername,
        password: HiveMqConstant.mqttPassword,
      ) {
    _init();
  }

  // ─── Public API ───────────────────────────────────────────────────────────

  Future<void> connect() => _manager.connect();

  /// Synchronizes the connection status.
  /// If disconnected, it attempts to connect.
  /// If already connected, it sends an 'online' status update.
  void syncConnection() {
    final connected = _manager.isConnected;
    if (kDebugMode) print('🔄 syncConnection: isConnected=$connected');

    if (!connected) {
      _manager.connect();
    } else {
      _publishAppOnline();
    }
  }

  Future<void> publishCommand(String command) async {
    await _manager.waitForConnection();
    final payload = MqttClientPayloadBuilder()..addString(command);
    _manager.publish(
      HiveMqConstant.topicCommand.topic,
      HiveMqConstant.topicCommand.qos,
      payload.payload!,
    );
    if (kDebugMode) {
      print(
        '📤 Published: $command → ${HiveMqConstant.topicCommand.topic} '
        '[QoS ${HiveMqConstant.topicCommand.qos.index}]',
      );
    }
  }

  void dispose() {
    _connectionSubscription?.cancel();
    _messageSubscription?.cancel();
    _manager.dispose();
    _subscribedTopics.clear();
    _bpController.close();
    _bpLiveController.close();
    _ecgController.close();
    _oximeterController.close();
    _deviceStatusController.close();
    _connectionController.close();
  }

  // ─── Private ──────────────────────────────────────────────────────────────

  void _init() {
    _connectionSubscription = _manager.connectionStatusStream.listen((
      isConnected,
    ) {
      _connectionController.add(isConnected);
      if (isConnected) {
        _subscribeToTopics();
        _publishAppOnline();
      } else {
        // Clear subscribed set on disconnect so topics are re-subscribed
        // after a full reconnect (broker state was lost).
        _subscribedTopics.clear();
      }
    });

    _messageSubscription = _manager.messageStream.listen(_onMessage);
  }

  void _subscribeToTopics() {
    for (final config in HiveMqConstant.subscribeTopics) {
      if (_subscribedTopics.contains(config.topic)) {
        if (kDebugMode) {
          print('⏭️ Already subscribed: ${config.topic}');
        }
        continue;
      }
      _manager.subscribe(config.topic, config.qos);
      _subscribedTopics.add(config.topic);
      if (kDebugMode) {
        print(
          '📋 Subscribed: ${config.topic} '
          '[QoS ${config.qos.index}]',
        );
      }
    }
  }

  void _onMessage(List<MqttReceivedMessage<MqttMessage>> events) {
    final topic = events[0].topic;
    final raw = (events[0].payload as MqttPublishMessage).payload.message;
    final payload = MqttPublishPayload.bytesToStringAsString(raw);
    if (kDebugMode) print('📥 MQTT [$topic]: $payload');

    final data = MqttPayloadParser.parse(topic, payload);
    if (data == null) return;

    switch (topic) {
      case HiveMqConstant.kTopicBP:
        _bpController.add(data as BPModel);
      case HiveMqConstant.kTopicBPLive:
        _bpLiveController.add((data as num).toDouble());
      case HiveMqConstant.kTopicEcg:
        _ecgController.add((data as num).toDouble());
      case HiveMqConstant.kTopicOximeter:
        _oximeterController.add(data as OximeterModel);
      case HiveMqConstant.kTopicAppStatus:
        _deviceStatusController.add(data as bool);
    }
  }

  void _publishAppOnline() {
    final payload = MqttClientPayloadBuilder()..addString('appOnline');
    // retain: true → broker stores this message; new subscribers
    // immediately receive the last known device status on connect.
    _manager.publish(
      HiveMqConstant.topicAppStatus.topic,
      HiveMqConstant.topicAppStatus.qos,
      payload.payload!,
      retain: true,
    );
    if (kDebugMode) print('📤 Published retained: online → status');
  }
}
