// lib/core/constants/app_constants.dart

class AppConstants {
  // MQTT Configuration
  static const String mqttBrokerUrl =
      '3b21c699ce40469c952aefc80b244ab2.s1.eu.hivemq.cloud';
  static const int mqttPort = 8883;
  static const String mqttClientId = 'bp_monitor_app';
  static const String mqttUsername = 'bloodPressure';
  static const String mqttPassword = 'comm-SBPM1';

  // MQTT Topics
  static const String topicMedicalData = 'medical/data';
  static const String topicMedicalCommand = 'medical/command';

  // Firebase Configuration
  static const String firestorePatientsCollection = 'patients';
  static const String firestoreSessionsSubcollection = 'sessions';

  // App Identifiers
  static const String defaultPatientId =
      'patient_123'; // Using a default patient for this demo
}
