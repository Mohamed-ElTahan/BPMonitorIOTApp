import 'dart:convert';
import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

/// A clean example of how to connect to HiveMQ Cloud and send data to a topic.
/// This example uses the credentials found in the project's AppConstants.
void main() async {
  // 1. Setup the client
  final String broker = 'baecf45d3be147d89925b349a789b8f5.s1.eu.hivemq.cloud';
  final int port = 8883;
  final String clientId = 'hivemq_example_client';
  final String username = 'CSBPM';
  final String password = 'comm-SBPM1';

  final client = MqttServerClient(broker, clientId);
  client.port = port;
  client.secure = true;
  client.securityContext = SecurityContext.defaultContext;
  client.keepAlivePeriod = 20;

  // 2. Setup the connection message
  final connMessage = MqttConnectMessage()
      .withClientIdentifier(clientId)
      .authenticateAs(username, password)
      .startClean();
  client.connectionMessage = connMessage;

  // 3. Connect to the broker
  try {
    print('Connecting to HiveMQ Cloud...');
    await client.connect();
    print('Successfully connected to HiveMQ');
  } catch (e) {
    print('Exception during connection: $e');
    client.disconnect();
    return;
  }

  // 4. Define the topic and data
  const String topicBP = 'CSBPM/bp';
  final Map<String, dynamic> data = {
    'systolic': 120,
    'diastolic': 80,
    'pulse': 72,
    'timestamp': DateTime.now().toIso8601String(),
    'note': 'Example message from HiveMQ example script',
  };

  // 5. Build and publish the message
  final builder = MqttClientPayloadBuilder();
  builder.addString(jsonEncode(data));

  print('Publishing message to topic: $topicBP');
  client.publishMessage(topicBP, MqttQos.atLeastOnce, builder.payload!);

  // 6. Wait a bit for the message to be sent and then disconnect
  await Future.delayed(const Duration(seconds: 2));
  print('Disconnecting...');
  client.disconnect();
  print('Done.');
}
