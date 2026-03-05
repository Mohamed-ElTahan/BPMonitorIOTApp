import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/data_source/mqtt_data_source.dart';
import '../models/vitals_model.dart';

class MonitorRepository {
  final MqttDataSource mqtt;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  MonitorRepository(this.mqtt);

  Stream<VitalsModel> getVitalsData() {
    return mqtt.bpStream.map((model) {
      _firestore.collection("vitals").add(model.toJson());
      return model;
    });
  }

  Stream<bool> getDeviceStatus() {
    return mqtt.deviceStatusStream;
  }

  void sendCommand(String command) {
    mqtt.publishCommand(command);
  }

  Stream<bool> getConnectionStatus() {
    return mqtt.connectionStream;
  }

  Stream<int> getBPLiveStream() {
    return mqtt.bpLiveStream;
  }

  Stream<double> getEcgStream() {
    return mqtt.ecgStream;
  }

  Stream<Map<String, dynamic>> getOximeterStream() {
    return mqtt.oximeterStream;
  }
}
