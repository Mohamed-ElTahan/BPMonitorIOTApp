import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:typed_data/typed_buffers.dart' show Uint8Buffer;
import '../../constants/app_constants.dart';

// Manages the full MQTT lifecycle: connect, reconnect, subscribe, publish.
class MqttClientManager {
  // ─── Config ───────────────────────────────────────────────────────────────
  final String broker;
  final int port;
  final String username;
  final String password;

  // ─── State ────────────────────────────────────────────────────────────────
  late MqttServerClient client;
  int _reconnectAttempts = 0;
  bool _isConnecting = false;
  bool _isDisposed = false;
  bool _isInitialized = false;
  Timer? _reconnectTimer;
  StreamSubscription? _updatesSubscription;
  Completer<void> _connectionCompleter = Completer<void>();

  // ─── Streams ──────────────────────────────────────────────────────────────
  final _connectionStatusController = StreamController<bool>.broadcast();
  Stream<bool> get connectionStatusStream => _connectionStatusController.stream;

  final _messageController =
      StreamController<List<MqttReceivedMessage<MqttMessage>>>.broadcast();
  Stream<List<MqttReceivedMessage<MqttMessage>>> get messageStream =>
      _messageController.stream;

  // ─── Constructor ──────────────────────────────────────────────────────────
  MqttClientManager({
    required this.broker,
    required this.port,
    required this.username,
    required this.password,
  });

  // ─── Public API ───────────────────────────────────────────────────────────

  Future<void> connect() async {
    final connected = isConnected;
    if (kDebugMode)
      _log(
        '🔌 Connect requested: isConnected=$connected, isConnecting=$_isConnecting',
      );

    if (connected || _isConnecting || _isDisposed) {
      if (kDebugMode && connected)
        _log('⏭️ Already connected, skipping connect()');
      return;
    }
    _isConnecting = true;
    final clientId = 'flutter_${DateTime.now().millisecondsSinceEpoch}';

    _log('🔌 Connecting to $broker:$port');

    _setupClient(clientId);
    client.connectionMessage = MqttConnectMessage()
        .withClientIdentifier(clientId)
        .authenticateAs(username, password)
        .startClean()
        .withWillTopic(AppConstants.topicStatus)
        .withWillMessage('offline')
        .withWillQos(MqttQos.atLeastOnce);

    try {
      await client.connect();
    } catch (e) {
      _log('❌ Connection failed: $e');
      _scheduleReconnect();
    }

    _isConnecting = false;
  }

  void subscribe(String topic, MqttQos qos) {
    if (isConnected) client.subscribe(topic, qos);
  }

  void publish(String topic, MqttQos qos, Uint8Buffer payload) {
    if (isConnected) client.publishMessage(topic, qos, payload);
  }

  Future<void> waitForConnection() async {
    if (!_isDisposed && !isConnected) {
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

  // ─── Public Getters ───────────────────────────────────────────────────────
  bool get isConnected =>
      _isInitialized &&
      client.connectionStatus?.state == MqttConnectionState.connected;

  void _setupClient(String clientId) {
    client = MqttServerClient(broker, clientId)
      ..port = port
      ..secure = true
      ..keepAlivePeriod = 20
      ..autoReconnect = false
      ..onConnected = _onConnected
      ..onDisconnected = _onDisconnected;
    client.onBadCertificate = (dynamic _) => true; // Bypass SSL for development
    _isInitialized = true;
  }

  void _onConnected() {
    _log('✅ Connected to MQTT Broker');
    _reconnectAttempts = 0;
    _connectionStatusController.add(true);

    if (!_connectionCompleter.isCompleted) {
      _connectionCompleter.complete();
    }

    _updatesSubscription?.cancel();
    _updatesSubscription = client.updates!.listen((events) {
      if (!_messageController.isClosed) _messageController.add(events);
    });
  }

  void _onDisconnected() {
    _log('❌ Disconnected from MQTT Broker');
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
    _log('⏳ Retrying in $delay seconds...');
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(Duration(seconds: delay), connect);
  }

  // kDebugMode: only prints in debug builds, stripped out in release.
  void _log(String message) {
    if (kDebugMode) print(message);
  }
}
