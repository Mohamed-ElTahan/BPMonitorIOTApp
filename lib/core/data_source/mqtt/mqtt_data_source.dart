import 'dart:async';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:mqtt_client/mqtt_client.dart';
import '../../constants/app_constants.dart';
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

  // Expose the raw client for callers that need direct access (e.g. HomeCubit).
  MqttClient get client => _manager.client;

  // ─── Output Streams ───────────────────────────────────────────────────────
  final _bpController = StreamController<BPModel>.broadcast();
  final _bpLiveController = StreamController<int>.broadcast();
  final _ecgController = StreamController<double>.broadcast();
  final _oximeterController = StreamController<OximeterModel>.broadcast();
  final _deviceStatusController = StreamController<bool>.broadcast();
  final _connectionController = StreamController<bool>.broadcast();

  Stream<BPModel> get bpStream => _bpController.stream;
  Stream<int> get bpLiveStream => _bpLiveController.stream;
  Stream<double> get ecgStream => _ecgController.stream;
  Stream<OximeterModel> get oximeterStream => _oximeterController.stream;
  Stream<bool> get deviceStatusStream => _deviceStatusController.stream;
  Stream<bool> get connectionStream => _connectionController.stream;

  // ─── Constructor ──────────────────────────────────────────────────────────
  MqttDataSource()
    : _manager = MqttClientManager(
        broker: AppConstants.mqttBrokerUrl,
        port: AppConstants.mqttPort,
        username: AppConstants.mqttUsername,
        password: AppConstants.mqttPassword,
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
      AppConstants.topicCommand,
      MqttQos.atLeastOnce,
      payload.payload!,
    );
    if (kDebugMode)
      print('📤 Published: $command → ${AppConstants.topicCommand}');
  }

  void dispose() {
    _connectionSubscription?.cancel();
    _messageSubscription?.cancel();
    _manager.dispose();
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
      }
    });

    _messageSubscription = _manager.messageStream.listen(_onMessage);
  }

  void _subscribeToTopics() {
    final topics = [
      AppConstants.topicBP,
      AppConstants.topicBPLive,
      AppConstants.topicEcg,
      AppConstants.topicOximeter,
      AppConstants.topicStatus,
    ];
    for (final topic in topics) {
      _manager.subscribe(topic, MqttQos.atLeastOnce);
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
      case AppConstants.topicBP:
        _bpController.add(data as BPModel);
        break;
      case AppConstants.topicBPLive:
        _bpLiveController.add(data as int);
        break;
      case AppConstants.topicEcg:
        _ecgController.add(data as double);
        break;
      case AppConstants.topicOximeter:
        _oximeterController.add(data as OximeterModel);
        break;
      case AppConstants.topicStatus:
        _deviceStatusController.add(data as bool);
        break;
    }
  }

  void _publishAppOnline() {
    final payload = MqttClientPayloadBuilder()..addString('online');
    _manager.publish(
      AppConstants.topicStatus,
      MqttQos.atLeastOnce,
      payload.payload!,
    );
  }
}
