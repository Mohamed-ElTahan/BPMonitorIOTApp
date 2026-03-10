import 'package:bp_monitor_iot/features/monitor/models/bp_model.dart';

import '../../../core/data_source/mqtt/mqtt_data_source.dart';
import '../models/oximeter_model.dart';

class MonitorRepository {
  final MqttDataSource mqtt;
  MonitorRepository(this.mqtt);

  // send command to ESP32 to start/stop measurements
  void sendCommand(String command) {
    mqtt.publishCommand(command);
  }

  // get connection status for MQTT
  Stream<bool> getConnectionStatus() {
    return mqtt.connectionStream;
  }

  // get device status for ESP32
  Stream<bool> getDeviceStatus() {
    return mqtt.deviceStatusStream;
  }

  Stream<BPModel> getBPStream() {
    return mqtt.bpStream;
  }

  Stream<double> getBPLiveStream() {
    return mqtt.bpLiveStream;
  }

  Stream<double> getEcgStream() {
    return mqtt.ecgStream;
  }

  Stream<OximeterModel> getOximeterStream() {
    return mqtt.oximeterStream;
  }
}
