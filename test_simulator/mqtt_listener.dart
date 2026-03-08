import 'dart:async';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

const String broker = 'baecf45d3be147d89925b349a789b8f5.s1.eu.hivemq.cloud';
const int port = 8883;
const String username = 'CSBPM';
const String password = 'comm-SBPM1';

Future<void> main() async {
  final client = MqttServerClient(broker, 'test_listener');
  client.port = port;
  client.secure = true;
  client.logging(on: true);
  client.keepAlivePeriod = 20;

  final connMessage = MqttConnectMessage()
      .withClientIdentifier('test_listener')
      .authenticateAs(username, password)
      .startClean();
  client.connectionMessage = connMessage;

  try {
    print('Connecting listener...');
    await client.connect();
    print('Listener Connected');
  } catch (e) {
    print('Exception: $e');
    client.disconnect();
    return;
  }

  client.subscribe('CSBPM/#', MqttQos.atLeastOnce);

  client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
    final recMess = c[0].payload as MqttPublishMessage;
    final pt = MqttPublishPayload.bytesToStringAsString(
      recMess.payload.message,
    );
    print('Topic: ${c[0].topic}, Payload: $pt');
  });

  await Future.delayed(Duration(minutes: 5));
  client.disconnect();
}
