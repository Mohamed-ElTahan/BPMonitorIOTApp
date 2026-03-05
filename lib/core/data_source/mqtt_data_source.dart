import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_browser_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import '../../features/monitor/models/vitals_model.dart';
import '../constants/app_constants.dart';

class MqttDataSource {
  // ---------------------------------------------------------------------------
  // Configuration
  // ---------------------------------------------------------------------------
  final String broker = AppConstants.mqttBrokerUrl;
  final int port = kIsWeb
      ? AppConstants.mqttWebSocketPort
      : AppConstants.mqttPort;
  final String username = AppConstants.mqttUsername;
  final String password = AppConstants.mqttPassword;

  // ---------------------------------------------------------------------------
  // State
  // ---------------------------------------------------------------------------
  late MqttClient client;
  int _reconnectAttempts = 0;
  bool _isConnecting = false;
  bool _isDisposed = false;
  Timer? _reconnectTimer;
  StreamSubscription? _updatesSubscription;
  Completer<void> _connectionCompleter = Completer<void>();

  // ---------------------------------------------------------------------------
  // Streams
  // ---------------------------------------------------------------------------
  final _bpController = StreamController<VitalsModel>.broadcast();
  final _bpLiveController = StreamController<int>.broadcast();
  final _ecgController = StreamController<double>.broadcast();
  final _oximeterController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _deviceStatusController = StreamController<bool>.broadcast();
  final _connectionController = StreamController<bool>.broadcast();

  Stream<VitalsModel> get bpStream => _bpController.stream;
  Stream<int> get bpLiveStream => _bpLiveController.stream;
  Stream<double> get ecgStream => _ecgController.stream;
  Stream<Map<String, dynamic>> get oximeterStream => _oximeterController.stream;
  Stream<bool> get deviceStatusStream => _deviceStatusController.stream;
  Stream<bool> get connectionStream => _connectionController.stream;

  // ---------------------------------------------------------------------------
  // Connection Management
  // ---------------------------------------------------------------------------
  Future<void> connect() async {
    if (_isConnecting) return;
    _isConnecting = true;

    final clientId = "flutter_${DateTime.now().millisecondsSinceEpoch}";
    print("🔌 Connecting to MQTT Broker: $broker on port $port (Web: $kIsWeb)");

    _setupClient(clientId);

    final connMessage = MqttConnectMessage()
        .withClientIdentifier(clientId)
        .authenticateAs(username, password)
        .startClean()
        .withWillTopic(AppConstants.topicStatus)
        .withWillMessage("offline")
        .withWillQos(MqttQos.atLeastOnce);

    client.connectionMessage = connMessage;

    try {
      await client.connect();
    } catch (e) {
      print("❌ Connection failed: $e");
      _scheduleReconnect();
    }

    _isConnecting = false;
  }

  void _setupClient(String clientId) {
    if (kIsWeb) {
      client = MqttBrowserClient('wss://$broker/mqtt', clientId);
    } else {
      client = MqttServerClient(broker, clientId);
      client.port = port;
    }
    client.keepAlivePeriod = 20;
    client.autoReconnect = false;
    client.onConnected = _onConnected;
    client.onDisconnected = _onDisconnected;
  }

  void _scheduleReconnect() {
    _reconnectAttempts++;
    final delay = min(pow(2, _reconnectAttempts), 32).toInt();

    print("⏳ Retrying connection in $delay seconds...");
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(Duration(seconds: delay), connect);
  }

  // ---------------------------------------------------------------------------
  // MQTT Callbacks
  // ---------------------------------------------------------------------------
  void _onConnected() {
    print("✅ Connected");
    _reconnectAttempts = 0;
    _connectionController.add(true);

    if (!_connectionCompleter.isCompleted) {
      _connectionCompleter.complete();
    }

    _subscribeToTopics();

    _updatesSubscription?.cancel();
    _updatesSubscription = client.updates!.listen(_onMessage);

    publishAppOnline();
  }

  void _onDisconnected() {
    print("❌ Disconnected");
    _connectionController.add(false);

    if (_connectionCompleter.isCompleted) {
      _connectionCompleter = Completer<void>();
    }

    _scheduleReconnect();
  }

  void _subscribeToTopics() {
    final topics = [
      AppConstants.topicBP,
      AppConstants.topicBPLive,
      AppConstants.topicEcg,
      AppConstants.topicOximeter,
      AppConstants.topicStatus,
    ];

    for (var topic in topics) {
      client.subscribe(topic, MqttQos.atLeastOnce);
    }
  }

  void _onMessage(List<MqttReceivedMessage<MqttMessage>> events) {
    try {
      final topic = events[0].topic;
      final recMess = events[0].payload as MqttPublishMessage;
      final message = MqttPublishPayload.bytesToStringAsString(
        recMess.payload.message,
      );

      if (topic == AppConstants.topicBP && !_bpController.isClosed) {
        _bpController.add(VitalsModel.fromJson(jsonDecode(message)));
      } else if (topic == AppConstants.topicBPLive &&
          !_bpLiveController.isClosed) {
        final value = int.tryParse(message);
        if (value != null) _bpLiveController.add(value);
      } else if (topic == AppConstants.topicEcg && !_ecgController.isClosed) {
        final value = double.tryParse(message);
        if (value != null) _ecgController.add(value);
      } else if (topic == AppConstants.topicOximeter &&
          !_oximeterController.isClosed) {
        _oximeterController.add(jsonDecode(message) as Map<String, dynamic>);
      } else if (topic == AppConstants.topicStatus &&
          !_deviceStatusController.isClosed) {
        _deviceStatusController.add(message == "online");
      }
    } catch (e) {
      print("⚠️ Error processing MQTT message: $e");
    }
  }

  // ---------------------------------------------------------------------------
  // Publishing
  // ---------------------------------------------------------------------------
  Future<void> publishCommand(String command) async {
    await _waitForConnection("publish command: $command");
    if (_isDisposed) return;

    final builder = MqttClientPayloadBuilder()..addString(command);
    try {
      client.publishMessage(
        AppConstants.topicCommand,
        MqttQos.atLeastOnce,
        builder.payload!,
      );
      print("📤 Published command: $command to ${AppConstants.topicCommand}");
    } catch (e) {
      print("❌ Failed to publish command: $e");
    }
  }

  Future<void> publishAppOnline() async {
    await _waitForConnection("publish app online status");
    if (_isDisposed) return;

    final builder = MqttClientPayloadBuilder()..addString("online");
    try {
      client.publishMessage(
        AppConstants.topicStatus,
        MqttQos.atLeastOnce,
        builder.payload!,
      );
    } catch (e) {
      print("❌ Failed to publish app online status: $e");
    }
  }

  Future<void> _waitForConnection(String actionDescription) async {
    if (_isDisposed) return;
    if (client.connectionStatus?.state != MqttConnectionState.connected) {
      print("⏳ Waiting for connection to $actionDescription");
      await _connectionCompleter.future;
    }
  }

  // ---------------------------------------------------------------------------
  // Cleanup
  // ---------------------------------------------------------------------------
  void dispose() {
    _isDisposed = true;
    _reconnectTimer?.cancel();
    _updatesSubscription?.cancel();
    client.disconnect();

    _bpController.close();
    _bpLiveController.close();
    _ecgController.close();
    _oximeterController.close();
    _deviceStatusController.close();
    _connectionController.close();
  }
}
