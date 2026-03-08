import 'dart:async';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:mqtt_client/mqtt_client.dart';
import '../../constants/app_constants.dart';
import '../../../features/monitor/models/bp_model.dart';
import '../../../features/monitor/models/oximeter_model.dart';
import 'mqtt_client_manager.dart';
import 'mqtt_payload_parser.dart';

/// Facade for MQTT data operations, providing streams for different vitals.
/// This class orchestrates the connection management and payload parsing.
class MqttDataSource {
  final MqttClientManager _manager;
  MqttClient get client => _manager.client;
  StreamSubscription? _messageSubscription;
  StreamSubscription? _connectionSubscription;

  // ---------------------------------------------------------------------------
  // Streams
  // ---------------------------------------------------------------------------
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

  MqttDataSource()
    : _manager = MqttClientManager(
        broker: AppConstants.mqttBrokerUrl,
        port: AppConstants.mqttPort,
        username: AppConstants.mqttUsername,
        password: AppConstants.mqttPassword,
      ) {
    _init();
  }

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

  // ---------------------------------------------------------------------------
  // Connection Management
  // ---------------------------------------------------------------------------
  Future<void> connect() => _manager.connect();

  void _subscribeToTopics() {
    final topics = [
      AppConstants.topicBP,
      AppConstants.topicBPLive,
      AppConstants.topicEcg,
      AppConstants.topicOximeter,
      AppConstants.topicStatus,
    ];

    for (String topic in topics) {
      _manager.subscribe(topic, MqttQos.atLeastOnce);
    }
  }

  void _onMessage(List<MqttReceivedMessage<MqttMessage>> events) {
    final topic = events[0].topic;
    final recMess = events[0].payload as MqttPublishMessage;
    final payload = MqttPublishPayload.bytesToStringAsString(
      recMess.payload.message,
    );

    final parsedData = MqttPayloadParser.parse(topic, payload);
    if (kDebugMode) {
      print('📥 MQTT [Subscribed]: Topic: $topic, Payload: $payload');
    }

    switch (topic) {
      case AppConstants.topicBP:
        _bpController.add(parsedData as BPModel);
        break;
      case AppConstants.topicBPLive:
        _bpLiveController.add(parsedData as int);
        break;
      case AppConstants.topicEcg:
        _ecgController.add(parsedData as double);
        break;
      case AppConstants.topicOximeter:
        _oximeterController.add(parsedData as OximeterModel);
        break;
      case AppConstants.topicStatus:
        _deviceStatusController.add(parsedData as bool);
        break;
    }
  }

  // ---------------------------------------------------------------------------
  // Publishing
  // ---------------------------------------------------------------------------
  Future<void> publishCommand(String command) async {
    await _manager.waitForConnection();
    final builder = MqttClientPayloadBuilder()..addString(command);
    _manager.publish(
      AppConstants.topicCommand,
      MqttQos.atLeastOnce,
      builder.payload!,
    );
    if (kDebugMode) {
      print("📤 Published command: $command to ${AppConstants.topicCommand}");
    }
  }

  Future<void> _publishAppOnline() async {
    final builder = MqttClientPayloadBuilder()..addString("online");
    _manager.publish(
      AppConstants.topicStatus,
      MqttQos.atLeastOnce,
      builder.payload!,
    );
  }

  // ---------------------------------------------------------------------------
  // Cleanup
  // ---------------------------------------------------------------------------
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
}
