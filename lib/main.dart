import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'features/monitor/logic/cubit/monitor_cubit.dart';
import 'features/monitor/presentation/screens/dashboard_screen.dart';

void main() {
  runApp(const BPMonitorIoTApp());
}

class BPMonitorIoTApp extends StatelessWidget {
  const BPMonitorIoTApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BP Monitor IoT',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: BlocProvider(
        create: (context) => MonitorCubit()..connect('ws://192.168.4.1:81'),
        child: const DashboardScreen(),
      ),
    );
  }
}
