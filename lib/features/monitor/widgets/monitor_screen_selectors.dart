/// BlocSelector snapshot classes for [MonitorScreen].
///
/// Each snapshot holds only the slice of state that a particular widget zone
/// cares about. Implementing [==] and [hashCode] ensures [BlocSelector] only
/// triggers a rebuild when that slice actually changes.
library;

class VitalsSnapshot {
  final int hr;
  final int spo2;
  final double sys;
  final double dia;
  final List<double> livePressure;

  const VitalsSnapshot({
    required this.hr,
    required this.spo2,
    required this.sys,
    required this.dia,
    required this.livePressure,
  });

  const VitalsSnapshot.empty()
      : hr = 0,
        spo2 = 0,
        sys = 0,
        dia = 0,
        livePressure = const [];

  @override
  bool operator ==(Object other) =>
      other is VitalsSnapshot &&
      hr == other.hr &&
      spo2 == other.spo2 &&
      sys == other.sys &&
      dia == other.dia &&
      livePressure == other.livePressure;

  @override
  int get hashCode => Object.hash(hr, spo2, sys, dia, livePressure);
}

class EcgSnapshot {
  final bool isConnected;
  final List<double> ecgData;

  const EcgSnapshot({required this.isConnected, required this.ecgData});

  @override
  bool operator ==(Object other) =>
      other is EcgSnapshot &&
      isConnected == other.isConnected &&
      ecgData == other.ecgData;

  @override
  int get hashCode => Object.hash(isConnected, ecgData);
}

class ControlsSnapshot {
  final bool isConnected;
  final bool isMeasuring;
  final bool isSaving;

  const ControlsSnapshot({
    required this.isConnected,
    required this.isMeasuring,
    required this.isSaving,
  });

  @override
  bool operator ==(Object other) =>
      other is ControlsSnapshot &&
      isConnected == other.isConnected &&
      isMeasuring == other.isMeasuring &&
      isSaving == other.isSaving;

  @override
  int get hashCode => Object.hash(isConnected, isMeasuring, isSaving);
}
