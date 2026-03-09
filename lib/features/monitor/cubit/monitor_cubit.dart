import 'dart:async';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/monitor_repository.dart';
import '../models/patient_measurement_model.dart';
import '../models/bp_model.dart';
import '../models/oximeter_model.dart';
import 'monitor_state.dart';
import '../../history/model/patient_model.dart';
import '../../../core/data_source/firebase/firestore_service.dart';

class MonitorCubit extends Cubit<MonitorState> {
  final MonitorRepository repository;
  final FirestoreService firestoreService;

  // Rolling list of ECG points (max 150 points for graph)
  final List<double> _rollingEcgPoints = [];
  final int _maxDataPoints = 150;

  bool _deviceOnline = false;

  StreamSubscription? _connectionSub;
  StreamSubscription? _deviceSub;
  StreamSubscription? _bpSub;
  StreamSubscription? _bpLiveSub;
  StreamSubscription? _ecgSub;
  StreamSubscription? _oximeterSub;

  MonitorCubit(this.repository, this.firestoreService)
    : super(MonitorInitial());

  void initialize() {
    final currentlyConnected = repository.mqtt.isConnected;
    if (currentlyConnected) {
      emit(
        MonitorConnected(
          currentVitals: PatientMeasurementModel(
            ecg: const [],
            oximeter: OximeterModel(spo2: 0, heartRate: 0),
            bP: BPModel(systolic: 0, diastolic: 0),
            livePressure: const [],
            timestamp: DateTime.now(),
          ),
        ),
      );
    } else {
      emit(MonitorConnecting());
    }

    // Attach listeners immediately
    _connectionSub = repository.getConnectionStatus().listen((connected) {
      if (!connected && state is MonitorConnected) {
        emit(const MonitorDisconnected());
      } else if (connected && state is! MonitorConnected) {
        emit(
          MonitorConnected(
            currentVitals: PatientMeasurementModel(
              ecg: const [],
              oximeter: OximeterModel(spo2: 0, heartRate: 0),
              bP: BPModel(systolic: 0, diastolic: 0),
              livePressure: const [],
              timestamp: DateTime.now(),
            ),
          ),
        );
      }
    });

    _deviceSub = repository.getDeviceStatus().listen((isOnline) {
      _deviceOnline = isOnline;
      if (state is MonitorConnected) {
        // We trigger an update to reflect the device status if needed
        _updateState((state as MonitorConnected).currentVitals);
      }
    });

    _bpLiveSub = repository.getBPLiveStream().listen((bpLive) {
      if (state is MonitorConnected) {
        final current = (state as MonitorConnected).currentVitals;
        _updateState(
          current.copyWith(
            livePressure: [bpLive.toDouble()],
            timestamp: DateTime.now(),
          ),
        );
      }
    });

    _bpSub = repository.getBPStream().listen((bpModel) {
      if (state is MonitorConnected) {
        final current = (state as MonitorConnected).currentVitals;
        _updateState(current.copyWith(bP: bpModel, timestamp: DateTime.now()));
      }
    });

    _ecgSub = repository.getEcgStream().listen((ecgPoint) {
      if (state is MonitorConnected) {
        final current = (state as MonitorConnected).currentVitals;
        _updateState(
          current.copyWith(ecg: [ecgPoint], timestamp: DateTime.now()),
        );
      }
    });

    _oximeterSub = repository.getOximeterStream().listen((oxi) {
      if (state is MonitorConnected) {
        final current = (state as MonitorConnected).currentVitals;
        _updateState(
          current.copyWith(oximeter: oxi, timestamp: DateTime.now()),
        );
      }
    });

    // Start connection in background
    repository.mqtt.connect();
  }

  void _updateState(PatientMeasurementModel vitals) {
    if (state is! MonitorConnected) return;

    String currentStatus = 'Connected to HiveMQ';

    // Add new ECG points to rolling history
    _rollingEcgPoints.addAll(vitals.ecg);

    // Trim history if it exceeds max length
    while (_rollingEcgPoints.length > _maxDataPoints) {
      _rollingEcgPoints.removeAt(0);
    }

    final updatedHistory = List<double>.from(_rollingEcgPoints);

    emit(
      MonitorConnected(
        currentVitals: vitals.copyWith(
          ecgHistory: updatedHistory,
          connectionStatus: currentStatus,
          deviceOnline: _deviceOnline,
        ),
      ),
    );
  }

  void startMeasurement() {
    repository.sendCommand('start');
  }

  void stopMeasurement() {
    repository.sendCommand('stop');
  }

  void disconnect() {
    repository.mqtt.dispose();
    emit(const MonitorDisconnected());
  }

  Future<void> saveVitals({
    required String name,
    required String sex,
    required int age,
  }) async {
    if (state is! MonitorConnected) return;
    final vitals = (state as MonitorConnected).currentVitals;

    final historyEntry = PatientModel(
      name: name,
      sex: sex,
      age: age,
      bloodPressure: "${vitals.bP.systolic}/${vitals.bP.diastolic}",
      livePressure: vitals.livePressure.map((e) => e.toInt()).toList(),
      heartRate: vitals.oximeter.heartRate,
      spo2: vitals.oximeter.spo2,
      ecg: vitals.ecgHistory,
      timestamp: DateTime.now(),
    );

    try {
      await firestoreService.saveHistory(historyEntry);
    } catch (e) {
      if (kDebugMode) print('❌ Error saving vitals: $e');
    }
  }

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
