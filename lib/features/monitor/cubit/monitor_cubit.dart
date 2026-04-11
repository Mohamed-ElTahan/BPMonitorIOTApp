import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/monitor_repository.dart';
import '../models/patient_measurement_model.dart';
import '../models/bp_model.dart';
import '../models/oximeter_model.dart';
import 'monitor_state.dart';
import 'bp_estimator.dart';
import '../../history/model/patient_model.dart';
import '../../../core/data_source/firebase/firestore_data_source.dart';

class MonitorCubit extends Cubit<MonitorState> {
  final MonitorRepository repository;
  final FirestoreDataSource firestoreService;

  // Rolling buffers for ECG and BP points (max 150 points for graph).
  final List<double> _rollingEcgPoints = [];
  final List<double> _rollingBpPoints = [];
  static const int _maxEcgPoints = 1000;
  static const int _maxBpPoints = 300;

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

    _bpLiveSub = repository.getBPLiveStream().listen((bpLiveList) {
      if (kDebugMode && bpLiveList.isNotEmpty) {
        debugPrint('🩸 BP Live Received: ${bpLiveList.length} pts');
      }
      _updateVitals(bpLiveChunk: bpLiveList);
    });

    _bpSub = repository.getBPStream().listen((bpModel) {
      if (kDebugMode) {
        debugPrint(
          '🩺 BP Static Received: ${bpModel.systolic}/${bpModel.diastolic}',
        );
      }
      _updateVitals(bloodPressure: bpModel);
    });

    _ecgSub = repository.getEcgStream().listen((ecgList) {
      if (kDebugMode && ecgList.isNotEmpty) {
        debugPrint('🫀 ECG Received: ${ecgList.length} pts');
      }
      _updateVitals(ecgChunk: ecgList);
    });

    _oximeterSub = repository.getOximeterStream().listen((oxi) {
      if (kDebugMode) {
        debugPrint('⌚ Oximeter Received: HR ${oxi.heartRate}, SpO2 ${oxi.spo2}');
      }
      _updateVitals(oximeter: oxi);
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
      estimatedBloodPressure: BPModel(systolic: 0.0, diastolic: 0.0),
      oximeter: OximeterModel(spo2: 0, heartRate: 0),
      livePressure: const [],
      ecg: const [],
    );
  }

  /// Appends incoming ECG points to the rolling buffer (O(n) trim via sublist),
  /// then emits a new [MonitorConnected] state preserving existing flags.
  void _updateVitals({
    List<double>? ecgChunk,
    List<double>? bpLiveChunk,
    BPModel? bloodPressure,
    OximeterModel? oximeter,
  }) {
    if (state is! MonitorConnected) return;

    final current = state as MonitorConnected;

    final hasNewEcg = ecgChunk != null && ecgChunk.isNotEmpty;
    final hasNewBp = bpLiveChunk != null && bpLiveChunk.isNotEmpty;

    // Append new ECG points.
    if (hasNewEcg) {
      _rollingEcgPoints.addAll(ecgChunk);
      if (_rollingEcgPoints.length > _maxEcgPoints) {
        _rollingEcgPoints.removeRange(
          0,
          _rollingEcgPoints.length - _maxEcgPoints,
        );
      }
    }

    // Append new BP points.
    if (hasNewBp) {
      // Clamp values to minimum 0.0 as requested
      final clampedPoints = bpLiveChunk.map((v) => v < 0 ? 0.0 : v);
      _rollingBpPoints.addAll(clampedPoints);
      if (_rollingBpPoints.length > _maxBpPoints) {
        _rollingBpPoints.removeRange(
          0,
          _rollingBpPoints.length - _maxBpPoints,
        );
      }
    }

    final updatedVitals = current.currentVitals;

    emit(
      current.copyWithState(
        currentVitals: updatedVitals.copyWith(
          bloodPressure: bloodPressure ?? updatedVitals.bloodPressure,
          oximeter: oximeter ?? updatedVitals.oximeter,
          // REFERENCE STABILITY:
          // Only emit a NEW list if we actually added data to it.
          // This prevents charts from rebuilding when unrelated data (e.g. HR) arrives.
          ecg:
              hasNewEcg
                  ? List<double>.from(_rollingEcgPoints)
                  : updatedVitals.ecg,
          livePressure:
              hasNewBp
                  ? List<double>.from(_rollingBpPoints)
                  : updatedVitals.livePressure,
          estimatedBloodPressure: BpEstimator.estimate(
            (oximeter ?? updatedVitals.oximeter).heartRate,
            (oximeter ?? updatedVitals.oximeter).spo2,
          ),
        ),
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

  void changeChart(int index) {
    if (state is! MonitorConnected) return;
    final current = state as MonitorConnected;
    emit(current.copyWithState(currentChartIndex: index));
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
          estimatedBloodPressure: vitals.estimatedBloodPressure,
          oximeter: vitals.oximeter,
          livePressure: vitals.livePressure,
          ecg: vitals.ecg,
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
      debugPrint('Error fetching historical data: $e');
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
