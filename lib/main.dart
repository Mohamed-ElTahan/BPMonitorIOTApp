import 'package:bp_monitor_iot/features/main_scaffold/main_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'core/data_source/mqtt/mqtt_data_source.dart';
import 'features/monitor/repository/monitor_repository.dart';
import 'features/history/repository/history_repository.dart';
import 'core/cubits/mqtt_connection_cubit.dart';
import 'core/cubits/wifi_cubit.dart';
import 'core/data_source/firebase/firestore_data_source.dart';
import 'core/widgets/no_connection_screen.dart';
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
        RepositoryProvider(create: (_) => FirestoreDataSource()),
        RepositoryProvider(
          create: (context) =>
              HistoryRepository(context.read<FirestoreDataSource>()),
        ),
        RepositoryProvider(
          create: (context) =>
              MonitorRepository(context.read<MqttDataSource>()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => WifiCubit()),
          BlocProvider(
            create: (context) =>
                MqttConnectionCubit(context.read<MqttDataSource>()),
          ),
        ],
        child: MaterialApp(
          title: 'BP Monitor IOT',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: BlocBuilder<WifiCubit, WifiStatus>(
            builder: (context, status) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (child, animation) =>
                    FadeTransition(opacity: animation, child: child),
                child: status == WifiStatus.none
                    ? const NoConnectionScreen(key: ValueKey('no-conn'))
                    : const MainScaffold(key: ValueKey('main')),
              );
            },
          ),
        ),
      ),
    );
  }
}
