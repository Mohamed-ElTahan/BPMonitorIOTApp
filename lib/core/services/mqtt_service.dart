// lib/core/services/mqtt_service.dart

import 'dart:convert';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import '../../features/monitor/models/vitals_model.dart';
import '../constants/app_constants.dart';

class MqttService {
  late MqttServerClient _client;
  Function(VitalsModel)? onDataReceived;
  Function(String)? onConnectionStatusChanged;

  Future<void> initializeAndConnect() async {
    _client = MqttServerClient.withPort(
      AppConstants.mqttBrokerUrl,
      AppConstants.mqttClientId,
      AppConstants.mqttPort,
    );

    // Required configuration for HiveMQ Cloud
    _client.logging(on: false);
    _client.keepAlivePeriod = 60;
    _client.secure = true;
    _client.onConnected = _onConnected;
    _client.onDisconnected = _onDisconnected;
    _client.onSubscribed = _onSubscribed;
    _client.pongCallback = _pong;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier(AppConstants.mqttClientId)
        .authenticateAs(AppConstants.mqttUsername, AppConstants.mqttPassword)
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);

    _client.connectionMessage = connMessage;

    try {
      onConnectionStatusChanged?.call('Connecting to MQTT broker...');
      await _client.connect();
    } catch (e) {
      onConnectionStatusChanged?.call('Exception during connection: $e');
      _client.disconnect();
      return;
    }

    if (_client.connectionStatus!.state == MqttConnectionState.connected) {
      onConnectionStatusChanged?.call('Connected to HiveMQ');
      _subscribeToTopic(AppConstants.topicMedicalData);
    } else {
      onConnectionStatusChanged?.call(
        'Failed to connect, status is ${_client.connectionStatus!.state}',
      );
      _client.disconnect();
    }
  }

  void _subscribeToTopic(String topic) {
    _client.subscribe(topic, MqttQos.atLeastOnce);
    _client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final pt = MqttPublishPayload.bytesToStringAsString(
        recMess.payload.message,
      );

      try {
        final Map<String, dynamic> jsonData = jsonDecode(pt);
        final vitals = VitalsModel.fromJson(jsonData);
        onDataReceived?.call(vitals);
      } catch (e) {
        print('Error parsing MQTT message: $e');
      }
    });
  }

  void publishCommand(String command) {
    if (_client.connectionStatus?.state == MqttConnectionState.connected) {
      final builder = MqttClientPayloadBuilder();
      builder.addString(command);
      _client.publishMessage(
        AppConstants.topicMedicalCommand,
        MqttQos.atMostOnce,
        builder.payload!,
      );
    } else {
      print('Cannot publish command. MQTT client is disconnected.');
    }
  }

  // MQTT Callbacks
  void _onConnected() {
    print('MQTT Client connected....');
  }

  void _onDisconnected() {
    print('MQTT Client disconnected');
    onConnectionStatusChanged?.call('Disconnected from broker');
  }

  void _onSubscribed(String topic) {
    print('MQTT Client Subscribed to topic: $topic');
  }

  void _pong() {
    print('MQTT Ping response client callback invoked');
  }

  void disconnect() {
    _client.disconnect();
  }
}
