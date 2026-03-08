import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:typed_data/typed_buffers.dart' show Uint8Buffer;
import '../../constants/app_constants.dart';

/// Manages the MQTT client connection lifecycle, including reconnection logic.
class MqttClientManager {
  final String broker;
  final int port;
  final String username;
  final String password;

  late MqttClient client;
  int _reconnectAttempts = 0;
  bool _isConnecting = false;
  bool _isDisposed = false;
  Timer? _reconnectTimer;
  StreamSubscription? _updatesSubscription;
  Completer<void> _connectionCompleter = Completer<void>();

  final _connectionStatusController = StreamController<bool>.broadcast();
  Stream<bool> get connectionStatusStream => _connectionStatusController.stream;

  final _messageController =
      StreamController<List<MqttReceivedMessage<MqttMessage>>>.broadcast();
  Stream<List<MqttReceivedMessage<MqttMessage>>> get messageStream =>
      _messageController.stream;

  MqttClientManager({
    required this.broker,
    required this.port,
    required this.username,
    required this.password,
  });

  Future<void> connect() async {
    if (_isConnecting || _isDisposed) return;
    _isConnecting = true;

    final clientId = "flutter_${DateTime.now().millisecondsSinceEpoch}";
    if (kDebugMode) {
      print("🔌 Connecting to MQTT Broker: $broker on port $port");
    }

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
      if (kDebugMode) {
        print("❌ Connection failed: $e");
      }
      _scheduleReconnect();
    }

    _isConnecting = false;
  }

  void _setupClient(String clientId) {
    client = MqttServerClient(broker, clientId);
    client.port = port;
    (client as MqttServerClient).secure = true;
    (client as MqttServerClient).onBadCertificate = (dynamic cert) => true;

    client.keepAlivePeriod = 20;
    client.autoReconnect = false;
    client.onConnected = _onConnected;
    client.onDisconnected = _onDisconnected;
  }

  void _onConnected() {
    if (kDebugMode) {
      print("✅ Connected to MQTT Broker");
    }
    _reconnectAttempts = 0;
    _connectionStatusController.add(true);

    if (!_connectionCompleter.isCompleted) {
      _connectionCompleter.complete();
    }

    _updatesSubscription?.cancel();
    _updatesSubscription = client.updates!.listen((events) {
      if (!_messageController.isClosed) {
        _messageController.add(events);
      }
    });
  }

  void _onDisconnected() {
    if (kDebugMode) {
      print("❌ Disconnected from MQTT Broker");
    }
    _connectionStatusController.add(false);

    if (_connectionCompleter.isCompleted) {
      _connectionCompleter = Completer<void>();
    }

    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    if (_isDisposed) return;

    _reconnectAttempts++;
    final delay = min(pow(2, _reconnectAttempts), 32).toInt();

    if (kDebugMode) {
      print("⏳ Retrying connection in $delay seconds...");
    }
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(Duration(seconds: delay), connect);
  }

  void subscribe(String topic, MqttQos qos) {
    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      client.subscribe(topic, qos);
    }
  }

  void publish(String topic, MqttQos qos, Uint8Buffer payload) {
    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      client.publishMessage(topic, qos, payload);
    }
  }

  Future<void> waitForConnection() async {
    if (_isDisposed) return;
    if (client.connectionStatus?.state != MqttConnectionState.connected) {
      await _connectionCompleter.future;
    }
  }

  void dispose() {
    _isDisposed = true;
    _reconnectTimer?.cancel();
    _updatesSubscription?.cancel();
    client.disconnect();
    _connectionStatusController.close();
    _messageController.close();
  }
}
