import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../data/models/vitals_model.dart';
import 'monitor_state.dart';

class MonitorCubit extends Cubit<MonitorState> {
  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  // Rolling list of ECG points (max 150 points for graph)
  final List<double> _rollingEcgPoints = [];
  final int _maxDataPoints = 150;

  // Assuming standard ESP32 WebSocket port
  // Replace with actual ESP32 IP or make it configurable
  String _wsUrl = 'ws://192.168.4.1:81';

  MonitorCubit() : super(MonitorInitial());

  void connect(String url) {
    if (url.isNotEmpty) {
      _wsUrl = url;
    }

    emit(MonitorConnecting());

    try {
      _channel = WebSocketChannel.connect(Uri.parse(_wsUrl));

      _subscription = _channel!.stream.listen(
        (data) {
          try {
            final decoded = jsonDecode(data);
            final vitals = VitalsModel.fromJson(decoded);
            _updateState(vitals);
          } catch (e) {
            // Handle JSON parsing errors or unexpected data format
            debugPrint('Error parsing data: $e');
          }
        },
        onError: (error) {
          emit(MonitorDisconnected(message: 'Connection Error: $error'));
          _scheduleReconnect();
        },
        onDone: () {
          emit(const MonitorDisconnected(message: 'Connection Closed'));
          _scheduleReconnect();
        },
      );
    } catch (e) {
      emit(MonitorDisconnected(message: 'Connection Failed: $e'));
      _scheduleReconnect();
    }
  }

  void _updateState(VitalsModel vitals) {
    // Update rolling ECG history
    _rollingEcgPoints.add(vitals.ecgValue);
    if (_rollingEcgPoints.length > _maxDataPoints) {
      _rollingEcgPoints.removeAt(0);
    }

    // Create a new list instance to ensure Bloc emits a state change
    final updatedHistory = List<double>.from(_rollingEcgPoints);

    emit(MonitorConnected(currentVitals: vitals, ecgHistory: updatedHistory));
  }

  void disconnect() {
    _subscription?.cancel();
    _channel?.sink.close();
    emit(const MonitorDisconnected(message: 'Disconnected by user'));
  }

  void _scheduleReconnect() {
    // Simple reconnect logic after a delay
    // In a real app, might want exponentional backoff or user prompt
    Future.delayed(const Duration(seconds: 3), () {
      if (state is MonitorDisconnected) {
        // Attempt to reuse last URL
        connect(_wsUrl);
      }
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _channel?.sink.close();
    return super.close();
  }
}
