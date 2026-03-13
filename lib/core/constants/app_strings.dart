class AppStrings {
  // General
  static const String appName = 'CSBPM';
  static const String appNameSubtitle = 'BP Monitor IOT';
  static const String version = 'Version 1.0.0';
  static const String cancel = 'Cancel';
  static const String save = 'Save';
  static const String retry = 'Retry';
  static const String delete = 'Delete';
  static const String analysis = 'Analysis';
  static const String recordDetails = 'Record Details';

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
      'CSBPM is a Communication Smart Blood Pressure Monitor using IoT technology. This comprehensive platform allows for continuous real-time monitoring of essential vitals, including blood pressure, heart rate, oxygen saturation (SpO2), and ECG waveforms. It seamlessly connects to smart health devices to provide accurate readings and in-depth historical data analysis, empowering patients and healthcare providers to make informed health decisions.';
  static String aboutCopyright(int year) =>
      '© $year BP Monitor IoT. All rights reserved.';

  // Team & Supervisor
  static const String teamInfo = 'Team Info';
  static const String teamDescription =
      'Our dedicated development team is committed to delivering high-quality healthcare solutions through innovative IoT technology.';
  static const String supervisor = 'Supervised By';
  static const String supervisorDescription =
      'Under professional guidance to ensure the highest standards of medical data accuracy and system reliability.';
  static const String supervisorName1 = 'Prof. Gamal El-Sheikh';
  static const String supervisorTitle1 = 'Project Supervisor';
  static const String supervisorName2 = 'Asst. Lecture Asmaa Radi';
  static const String supervisorTitle2 = 'Assistant Supervisor';
  static const String teamMembersLabel = 'Team Members:';
  static const String placeholderTeamMember1 = 'Lead Developer';
  static const String placeholderTeamMember2 = 'IoT Specialist';
  static const String placeholderTeamMember3 = 'UI/UX Designer';

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
