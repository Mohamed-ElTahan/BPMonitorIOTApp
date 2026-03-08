import 'package:bp_monitor_iot/features/home/cubit/home_cubit.dart';
import 'package:bp_monitor_iot/features/main/main_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'core/data_source/mqtt/mqtt_data_source.dart';
import 'features/monitor/repository/monitor_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (_) => MqttDataSource()..connect(),
          dispose: (ds) => ds.dispose(),
        ),
        RepositoryProvider(
          create: (context) =>
              MonitorRepository(context.read<MqttDataSource>()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                HomeCubit(context.read<MqttDataSource>().client),
          ),
        ],
        child: MaterialApp(
          title: 'BP Monitor IOT',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: const MainScaffold(),
        ),
      ),
    );
  }
}
