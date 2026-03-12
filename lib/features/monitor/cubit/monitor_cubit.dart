import 'dart:async';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/monitor_repository.dart';
import '../models/patient_measurement_model.dart';
import '../models/bp_model.dart';
import '../models/oximeter_model.dart';
import 'monitor_state.dart';
import '../../history/model/patient_model.dart';
import '../../../core/data_source/firebase/firestore_data_source.dart';

class MonitorCubit extends Cubit<MonitorState> {
  final MonitorRepository repository;
  final FirestoreDataSource firestoreService;

  // Rolling buffer for ECG points (max 150 points for graph).
  final List<double> _rollingEcgPoints = [];
  static const int _maxDataPoints = 150;

  StreamSubscription? _connectionSub;
  StreamSubscription? _deviceSub;
  StreamSubscription? _bpSub;
  StreamSubscription? _bpLiveSub;
  StreamSubscription? _ecgSub;
  StreamSubscription? _oximeterSub;

  MonitorCubit(this.repository, this.firestoreService)
    : super(MonitorInitial(currentVitals: _emptyVitals()));

  // ---------------------------------------------------------------------------
  // Initialization
  // ---------------------------------------------------------------------------

  void initialize() {
    final alreadyConnected = repository.mqtt.isConnected;

    emit(
      alreadyConnected
          ? MonitorConnected(currentVitals: _emptyVitals())
          : MonitorConnecting(),
    );

    _connectionSub = repository.getConnectionStatus().listen((connected) {
      if (!connected && state is MonitorConnected) {
        emit(const MonitorDisconnected());
      } else if (connected && state is! MonitorConnected) {
        emit(MonitorConnected(currentVitals: _emptyVitals()));
      }
    });

    _deviceSub = repository.getDeviceStatus().listen((isOnline) {
      // Offline status removed as it is now handled in the app bar
    });

    _bpLiveSub = repository.getBPLiveStream().listen((bpLive) {
      if (state is MonitorConnected) {
        final current = state as MonitorConnected;
        _updateVitals(
          current.currentVitals.copyWith(livePressure: [bpLive.toDouble()]),
        );
      }
    });

    _bpSub = repository.getBPStream().listen((bpModel) {
      if (state is MonitorConnected) {
        final current = state as MonitorConnected;
        _updateVitals(current.currentVitals.copyWith(bloodPressure: bpModel));
      }
    });

    _ecgSub = repository.getEcgStream().listen((ecgPoint) {
      if (state is MonitorConnected) {
        final current = state as MonitorConnected;
        _updateVitals(current.currentVitals.copyWith(ecg: [ecgPoint]));
      }
    });

    _oximeterSub = repository.getOximeterStream().listen((oxi) {
      if (state is MonitorConnected) {
        final current = state as MonitorConnected;
        _updateVitals(current.currentVitals.copyWith(oximeter: oxi));
      }
    });

    repository.mqtt.connect();
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  /// Returns a zeroed-out vitals object used when connection is first established.
  static PatientMeasurementModel _emptyVitals() {
    return PatientMeasurementModel(
      bloodPressure: BPModel(systolic: 0.0, diastolic: 0.0),
      oximeter: OximeterModel(spo2: 0, heartRate: 0),
      livePressure: const [],
      ecg: const [],
    );
  }

  /// Appends incoming ECG points to the rolling buffer (O(n) trim via sublist),
  /// then emits a new [MonitorConnected] state preserving existing flags.
  void _updateVitals(PatientMeasurementModel vitals) {
    if (state is! MonitorConnected) return;

    final current = state as MonitorConnected;

    // Append new ECG points.
    _rollingEcgPoints.addAll(vitals.ecg);

    // O(n) trim — drop oldest points when the buffer exceeds the cap.
    if (_rollingEcgPoints.length > _maxDataPoints) {
      final excess = _rollingEcgPoints.length - _maxDataPoints;
      _rollingEcgPoints.removeRange(0, excess);
    }

    emit(
      MonitorConnected(
        currentVitals: vitals.copyWith(
          ecg: List<double>.from(_rollingEcgPoints),
        ),
        isMeasuring: current.isMeasuring,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Public commands
  // ---------------------------------------------------------------------------

  void startMeasurement() {
    if (state is! MonitorConnected) return;
    final current = state as MonitorConnected;
    repository.sendCommand('start');
    emit(current.copyWithState(isMeasuring: true));
  }

  void stopMeasurement() {
    if (state is! MonitorConnected) return;
    final current = state as MonitorConnected;
    repository.sendCommand('stop');
    emit(current.copyWithState(isMeasuring: false));
  }

  void disconnect() {
    repository.mqtt.dispose();
    emit(const MonitorDisconnected());
  }

  /// Saves current vitals to Firestore.
  /// Emits [MonitorSaving] while in progress, then [MonitorSaveResult].
  Future<void> saveVitals({
    required String name,
    required String gender,
    required int age,
  }) async {
    if (state is! MonitorConnected) return;
    final current = state as MonitorConnected;
    final vitals = current.currentVitals;

    emit(
      MonitorSaving(currentVitals: vitals, isMeasuring: current.isMeasuring),
    );

    try {
      await firestoreService.saveHistory(
        PatientModel(
          name: name,
          gender: gender,
          age: age,
          timestamp: DateTime.now(),
          bloodPressure: vitals.bloodPressure,
          oximeter: vitals.oximeter,
          livePressure: vitals.livePressure.map((e) => e.toDouble()).toList(),
          ecg: const [],
        ),
      );

      emit(
        MonitorSaveResult(
          currentVitals: vitals,
          isMeasuring: current.isMeasuring,
          success: true,
        ),
      );
    } catch (e) {
      if (kDebugMode) print('❌ Error saving vitals: $e');
      emit(
        MonitorSaveResult(
          currentVitals: vitals,
          isMeasuring: current.isMeasuring,
          success: false,
          error: e.toString(),
        ),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  @override
  Future<void> close() {
    _connectionSub?.cancel();
    _deviceSub?.cancel();
    _bpSub?.cancel();
    _bpLiveSub?.cancel();
    _ecgSub?.cancel();
    _oximeterSub?.cancel();
    return super.close();
  }
}
