import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/navigation_cubit.dart';
import '../monitor/monitor_screen.dart';
import '../history/history_screen.dart';
import '../analysis/analysis_screen.dart';
import '../about/about_screen.dart';
import 'widgets/main_app_bar.dart';
import 'widgets/main_bottom_nav_bar.dart';
import '../../core/data_source/mqtt/mqtt_data_source.dart';

class MainScaffold extends StatelessWidget {
  const MainScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavigationCubit(),
      child: const _MainScaffold(),
    );
  }
}

class _MainScaffold extends StatelessWidget {
  const _MainScaffold();

  static final List<Widget> _screens = [
    const MonitorScreen(),
    const AnalysisScreen(),
    const HistoryScreen(),
    const AboutScreen(),
  ];

  static final List<String> _titles = [
    'Live Monitor',
    'Health Analysis',
    'Measurement History',
    'Application Info',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocListener<NavigationCubit, int>(
      listener: (context, index) {
        if (kDebugMode) print('🧭 Navigation: index=$index');
        if (index == 0) {
          context.read<MqttDataSource>().syncConnection();
        }
      },
      child: BlocBuilder<NavigationCubit, int>(
        builder: (context, currentIndex) {
          return Scaffold(
            appBar: MainAppBar(title: _titles[currentIndex]),
            body: _screens[currentIndex],
            bottomNavigationBar: MainBottomNavBar(
              currentIndex: currentIndex,
              onTap: (index) =>
                  context.read<NavigationCubit>().setScreen(index),
            ),
          );
        },
      ),
    );
  }
}
