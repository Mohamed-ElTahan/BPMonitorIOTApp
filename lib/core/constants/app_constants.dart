// lib/core/constants/app_constants.dart

class AppConstants {
  // MQTT Configuration
  static const String mqttBrokerUrl =
      'baecf45d3be147d89925b349a789b8f5.s1.eu.hivemq.cloud';
  static const int mqttPort = 8883;
  static const int mqttWebSocketPort = 8884;
  static const String mqttClientId = 'bp_monitor_app';
  static const String mqttUsername = 'CSBPM';
  static const String mqttPassword = 'comm-SBPM1';

  // MQTT Topics
  // subscribe topics
  static const String topicBP = 'CSBPM/bp';
  static const String topicBPLive = 'CSBPM/bpLive';
  static const String topicEcg = 'CSBPM/ecg';
  static const String topicOximeter = 'CSBPM/oximeter';
  static const String topicStatus = 'CSBPM/status';
  // publish topics
  static const String topicCommand = 'CSBPM/command';

  // Firebase Configuration
  static const String firestorePatientsCollection = 'patients';
  static const String firestoreSessionsSubcollection = 'sessions';

  // App Identifiers
  static const String defaultPatientId = 'patient_123';
}
