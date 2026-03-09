import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data_source/mqtt/mqtt_data_source.dart';

enum MqttConnectionStatus { disconnected, connecting, connected }

class MqttConnectionCubit extends Cubit<MqttConnectionStatus> {
  final MqttDataSource mqttDataSource;
  StreamSubscription? _subscription;

  MqttConnectionCubit(this.mqttDataSource)
    : super(MqttConnectionStatus.disconnected) {
    _init();
  }

  void _init() {
    _subscription = mqttDataSource.connectionStream.listen((isConnected) {
      emit(
        isConnected
            ? MqttConnectionStatus.connected
            : MqttConnectionStatus.disconnected,
      );
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
