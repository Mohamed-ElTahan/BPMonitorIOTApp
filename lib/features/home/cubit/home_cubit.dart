import 'package:bp_monitor_iot/features/home/cubit/home_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mqtt_client/mqtt_client.dart';

class HomeCubit extends Cubit<HomeStates> {
  final MqttClient client;
  HomeCubit(this.client) : super(InitialState());

  final MqttClientPayloadBuilder _p = MqttClientPayloadBuilder();

  // publish start/stop to HiveMq
  void publish(String topic, String commant) {
    _p.addString(commant);
    client.publishMessage(topic, MqttQos.atMostOnce, _p.payload!);
    _p.clear();
    emit(PublishState());
  }
}
