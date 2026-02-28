import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/services/firebase_service.dart';
import 'core/services/mqtt_service.dart';
import 'core/theme/app_theme.dart';
import 'features/monitor/cubit/monitor_cubit.dart';
import 'features/main/cubit/navigation_cubit.dart';
import 'features/history/cubit/history_cubit.dart';
import 'features/main/main_scaffold.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const BPMonitorIoTApp());
}

class BPMonitorIoTApp extends StatelessWidget {
  const BPMonitorIoTApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SBPM',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(create: (_) => MqttService()),
          RepositoryProvider(create: (_) => FirebaseService()),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => MonitorCubit(
                mqttService: context.read<MqttService>(),
                firebaseService: context.read<FirebaseService>(),
              )..connect(),
            ),
            BlocProvider(create: (context) => NavigationCubit()),
            BlocProvider(
              create: (context) =>
                  HistoryCubit(firebaseService: context.read<FirebaseService>())
                    ..loadHistory(),
            ),
          ],
          child: const MainScaffold(),
        ),
      ),
    );
  }
}
