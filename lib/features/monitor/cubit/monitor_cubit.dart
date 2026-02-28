import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/mqtt_service.dart';
import '../../../core/services/firebase_service.dart';
import '../models/vitals_model.dart';
import 'monitor_state.dart';

class MonitorCubit extends Cubit<MonitorState> {
  final MqttService mqttService;
  final FirebaseService firebaseService;

  // Rolling list of ECG points (max 150 points for graph)
  final List<double> _rollingEcgPoints = [];
  final int _maxDataPoints = 150;

  // Batch for Firebase
  final List<VitalsModel> _vitalsBatch = [];
  final int _batchSize = 10; // Save every 10 vitals

  MonitorCubit({required this.mqttService, required this.firebaseService})
    : super(MonitorInitial());

  Future<void> connect() async {
    emit(MonitorConnecting());

    mqttService.onConnectionStatusChanged = (status) {
      if (status.contains('Disconnected') || status.contains('Failed')) {
        emit(MonitorDisconnected(message: status));
      } else if (state is MonitorConnected) {
        emit((state as MonitorConnected).copyWith(connectionStatus: status));
      } else {
        emit(
          MonitorConnected(
            currentVitals: VitalsModel.empty(),
            ecgHistory: const [],
            connectionStatus: status,
          ),
        );
      }
    };

    mqttService.onDataReceived = (vitals) {
      _updateState(vitals);
      _handleFirebaseStorage(vitals);
    };

    await mqttService.initializeAndConnect();
  }

  void _updateState(VitalsModel vitals) {
    // Determine the current connection status from the existing state
    String currentStatus = 'Connected to HiveMQ';
    if (state is MonitorConnected) {
      currentStatus = (state as MonitorConnected).connectionStatus;
    }

    // Add new ECG points to rolling history
    _rollingEcgPoints.addAll(vitals.ecg);

    // Trim history if it exceeds max length
    while (_rollingEcgPoints.length > _maxDataPoints) {
      _rollingEcgPoints.removeAt(0);
    }

    // Create a new list instance to ensure Bloc emits a state change
    final updatedHistory = List<double>.from(_rollingEcgPoints);

    emit(
      MonitorConnected(
        currentVitals: vitals,
        ecgHistory: updatedHistory,
        connectionStatus: currentStatus,
        lastDataReceived: vitals.timestamp,
      ),
    );
  }

  void _handleFirebaseStorage(VitalsModel vitals) {
    _vitalsBatch.add(vitals);
    if (_vitalsBatch.length >= _batchSize) {
      firebaseService.saveVitalsBatch(List.from(_vitalsBatch));
      _vitalsBatch.clear();
    }
  }

  void startMeasurement() {
    mqttService.publishCommand('START');
  }

  void stopMeasurement() {
    mqttService.publishCommand('STOP');
    // Save remaining batch if any
    if (_vitalsBatch.isNotEmpty) {
      firebaseService.saveVitalsBatch(List.from(_vitalsBatch));
      _vitalsBatch.clear();
    }
  }

  void disconnect() {
    mqttService.disconnect();
    stopMeasurement();
    emit(const MonitorDisconnected(message: 'Disconnected by user'));
  }

  @override
  Future<void> close() {
    mqttService.disconnect();
    return super.close();
  }
}
