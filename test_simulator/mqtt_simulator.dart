import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

// Values from AppConstants
const String broker = 'baecf45d3be147d89925b349a789b8f5.s1.eu.hivemq.cloud';
const int port = 8883;
const String username = 'CSBPM';
const String password = 'comm-SBPM1';

const String topicBP = 'CSBPM/bp';
const String topicBPLive = 'CSBPM/bpLive';
const String topicEcg = 'CSBPM/ecg';
const String topicOximeter = 'CSBPM/oximeter';
const String topicStatus = 'CSBPM/status';

Future<void> main() async {
  final client = MqttServerClient(broker, 'test_simulator');
  client.port = port;
  client.secure = true;
  client.securityContext =
      SecurityContext.defaultContext; // Use default OS certs
  client.keepAlivePeriod = 20;
  client.onDisconnected = () => print('Disconnected');

  final connMessage = MqttConnectMessage()
      .withClientIdentifier('test_simulator')
      .authenticateAs(username, password)
      .startClean();
  client.connectionMessage = connMessage;

  try {
    print('Connecting...');
    await client.connect();
    print('Connected to HiveMQ');
  } catch (e) {
    print('Exception: $e');
    client.disconnect();
    return;
  }

  // Publish "online" status
  final statusBuilder = MqttClientPayloadBuilder()..addString('online');
  client.publishMessage(
    topicStatus,
    MqttQos.atLeastOnce,
    statusBuilder.payload!,
  );

  // Simulate data publishing
  Timer.periodic(Duration(seconds: 1), (timer) {
    if (client.connectionStatus!.state != MqttConnectionState.connected) {
      timer.cancel();
      return;
    }

    // Publish random BP
    final bpData = {
      'bp': 120 + Random().nextInt(20),
      'timestamp': DateTime.now().toIso8601String(),
    };
    final bpBuilder = MqttClientPayloadBuilder()..addString(jsonEncode(bpData));
    client.publishMessage(topicBP, MqttQos.atLeastOnce, bpBuilder.payload!);

    // Publish random Oximeter
    final oxiData = {
      'spo2': 95 + Random().nextInt(5),
      'hr': 60 + Random().nextInt(40),
    };
    final oxiBuilder = MqttClientPayloadBuilder()
      ..addString(jsonEncode(oxiData));
    client.publishMessage(
      topicOximeter,
      MqttQos.atLeastOnce,
      oxiBuilder.payload!,
    );

    // Publish random ECG point
    final ecgPoint = (Random().nextDouble() * 2) - 1;
    final ecgBuilder = MqttClientPayloadBuilder()
      ..addString(ecgPoint.toString());
    client.publishMessage(topicEcg, MqttQos.atLeastOnce, ecgBuilder.payload!);

    print('Published mock data at ${DateTime.now()}');
  });

  // Keep running for a while
  await Future.delayed(Duration(minutes: 5));
  client.disconnect();
}
