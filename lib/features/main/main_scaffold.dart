import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/navigation_cubit.dart';
import '../monitor/monitor_screen.dart';
import '../history/history_screen.dart';
import '../analysis/analysis_screen.dart';
import '../about/about_screen.dart';

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
    'Monitor',
    'Analysis',
    'History',
    'About',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, int>(
      builder: (context, currentIndex) {
        return Scaffold(
          // appBar
          appBar: AppBar(title: Text(_titles[currentIndex])),

          // body
          body: _screens[currentIndex],

          // bottomNavigationBar
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) {
              context.read<NavigationCubit>().setScreen(index);
            },
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.monitor_heart),
                label: 'Monitor',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.analytics),
                label: 'Analysis',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history),
                label: 'History',
              ),
              BottomNavigationBarItem(icon: Icon(Icons.info), label: 'About'),
            ],
          ),
        );
      },
    );
  }
}
