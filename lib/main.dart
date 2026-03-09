import 'package:bp_monitor_iot/features/main_scaffold/main_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'core/data_source/mqtt/mqtt_data_source.dart';
import 'features/monitor/repository/monitor_repository.dart';
import 'features/history/repository/history_repository.dart';
import 'core/cubits/mqtt_connection_cubit.dart';
import 'core/data_source/firebase/firestore_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
        RepositoryProvider(create: (_) => FirestoreService()),
        RepositoryProvider(
          create: (context) =>
              HistoryRepository(context.read<FirestoreService>()),
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
                MqttConnectionCubit(context.read<MqttDataSource>()),
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
