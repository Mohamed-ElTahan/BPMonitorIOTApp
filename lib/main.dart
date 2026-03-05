import 'package:bp_monitor_iot/features/main/main_scaffold.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'core/data_source/mqtt_data_source.dart';
import 'features/monitor/repository/monitor_repository.dart';
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
      title: 'CSBPM',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(
            create: (_) => MqttDataSource(),
            dispose: (ds) => ds.dispose(),
          ),
          RepositoryProvider(
            create: (context) =>
                MonitorRepository(context.read<MqttDataSource>()),
          ),
        ],
        child: const MainScaffold(),
      ),
    );
  }
}
