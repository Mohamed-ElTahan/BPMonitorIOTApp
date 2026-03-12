class AppStrings {
  // General
  static const String appName = 'CSBPM';
  static const String appNameSubtitle = 'BP Monitor IOT';
  static const String version = 'Version 1.0.0';
  static const String cancel = 'Cancel';
  static const String save = 'Save';
  static const String retry = 'Retry';
  static const String delete = 'Delete';

  // Units
  static const String unitMmHg = 'mmHg';
  static const String unitBpm = 'BPM';
  static const String unitPercentage = '%';

  // Vitals
  static const String livePressure = 'Live Pressure';
  static const String bloodPressure = 'Blood Pressure';
  static const String heartRate = 'Heart Rate';
  static const String spo2 = 'SpO2';

  // Monitor Screen
  static const String ecgWaveform = 'ECG Waveform';
  static const String waitingForSignal = 'Waiting for signal...';
  static const String start = 'Start';
  static const String stop = 'Stop';
  static const String saving = 'Saving…';
  static const String savingMeasurement = 'Saving measurement…';
  static const String measurementSavedSuccess = 'Measurement saved to history';
  static const String measurementSavedFailure = 'Failed to save: ';

  // History Screen
  static const String historyEmptyTitle = 'No history records found';
  static const String historyEmptySubtitle =
      'Start a measurement to see it here';
  static const String historyLoadFailure = 'Failed to load history';
  static const String historyDeleteSuccess = 'Record deleted successfully';
  static const String historyDeleteFailure = 'Failed to delete record: ';
  static const String confirmDeleteTitle = 'Confirm Delete';
  static const String confirmDeleteContent =
      'Are you sure you want to delete this record?';
  static const String unknownTime = 'Unknown Time';
  static const String statusNormal = 'Normal';
  static const String years = 'years';
  static const String deleteRecord = 'Delete record';

  // About Screen
  static const String aboutDescription =
      'A comprehensive IoT application for monitoring blood pressure, heart rate, oxygen saturation, and continuous ECG waveforms. Connect seamlessly to a smart monitor to track your vitals in real-time and review historical data analysis.';
  static String aboutCopyright(int year) =>
      '© $year BP Monitor IoT. All rights reserved.';

  // MQTT Status
  static const String brokerOnline = 'Broker: Online';
  static const String brokerConnecting = 'Broker: Connecting';
  static const String brokerOffline = 'Broker: Offline';

  // Dialogs
  static const String patientInfoTitle = 'Patient Information';
  static const String patientName = 'Patient Name';
  static const String enterName = 'Please enter a name';
  static const String ageLabel = 'Age';
  static const String enterAge = 'Please enter age';
  static const String invalidNumber = 'Please enter a valid number';
  static const String genderLabel = 'Gender';
  static const String genderMale = 'Male';
  static const String genderFemale = 'Female';
}
