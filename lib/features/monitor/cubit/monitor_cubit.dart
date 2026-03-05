import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/monitor_repository.dart';
import '../models/vitals_model.dart';
import 'monitor_state.dart';

class MonitorCubit extends Cubit<MonitorState> {
  final MonitorRepository repository;

  // Rolling list of ECG points (max 150 points for graph)
  final List<double> _rollingEcgPoints = [];
  final int _maxDataPoints = 150;

  bool _deviceOnline = false;

  StreamSubscription? _connectionSub;
  StreamSubscription? _deviceSub;
  StreamSubscription? _vitalsSub;
  StreamSubscription? _bpLiveSub;
  StreamSubscription? _ecgSub;
  StreamSubscription? _oximeterSub;

  MonitorCubit(this.repository) : super(MonitorInitial());

  void initialize() {
    emit(MonitorConnecting());

    // Attach listeners immediately
    _connectionSub = repository.getConnectionStatus().listen((connected) {
      if (!connected && state is MonitorConnected) {
        emit(const MonitorDisconnected(message: "Connection Lost"));
      } else if (connected && state is! MonitorConnected) {
        emit(
          MonitorConnected(
            currentVitals: VitalsModel.empty(),
            ecgHistory: const [],
            connectionStatus: "Connected to HiveMQ",
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

    _vitalsSub = repository.getVitalsData().listen((vitals) {
      if (state is MonitorConnected) {
        final current = (state as MonitorConnected).currentVitals;
        _updateState(
          current.copyWith(
            systolicBP: vitals.systolicBP,
            diastolicBP: vitals.diastolicBP,
            timestamp: vitals.timestamp,
          ),
        );
      }
    });

    _bpLiveSub = repository.getBPLiveStream().listen((bpLive) {
      if (state is MonitorConnected) {
        final current = (state as MonitorConnected).currentVitals;
        _updateState(current.copyWith(livePressure: [bpLive.toDouble()]));
      }
    });

    _ecgSub = repository.getEcgStream().listen((ecgPoint) {
      if (state is MonitorConnected) {
        final current = (state as MonitorConnected).currentVitals;
        _updateState(current.copyWith(ecg: [ecgPoint]));
      }
    });

    _oximeterSub = repository.getOximeterStream().listen((oxi) {
      if (state is MonitorConnected) {
        final current = (state as MonitorConnected).currentVitals;
        _updateState(
          current.copyWith(
            spo2: oxi['spo2'] as int? ?? current.spo2,
            heartRate: oxi['hr'] as int? ?? current.heartRate,
          ),
        );
      }
    });

    // Start connection in background
    repository.mqtt.connect();
  }

  void _updateState(VitalsModel vitals) {
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
        currentVitals: vitals,
        ecgHistory: updatedHistory,
        connectionStatus: currentStatus,
        lastDataReceived: vitals.timestamp,
        deviceOnline: _deviceOnline,
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
    emit(const MonitorDisconnected(message: 'Disconnected by user'));
  }

  @override
  Future<void> close() {
    _connectionSub?.cancel();
    _deviceSub?.cancel();
    _vitalsSub?.cancel();
    _bpLiveSub?.cancel();
    _ecgSub?.cancel();
    _oximeterSub?.cancel();
    return super.close();
  }
}
