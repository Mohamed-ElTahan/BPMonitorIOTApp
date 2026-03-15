import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../cubit/monitor_cubit.dart';
import '../cubit/monitor_state.dart';
import '../../../core/constants/app_strings.dart';
import 'ecg_chart_card_widget.dart';
import 'bp_chart_card_widget.dart';

class ChartsPanel extends StatefulWidget {
  const ChartsPanel({super.key});

  @override
  State<ChartsPanel> createState() => _ChartsPanelState();
}

class _ChartsPanelState extends State<ChartsPanel> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    // Initialize PageController with current index from state if possible
    final state = context.read<MonitorCubit>().state;
    final initialPage = state is MonitorConnected ? state.currentChartIndex : 0;
    _pageController = PageController(initialPage: initialPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MonitorCubit, MonitorState>(
      buildWhen: (prev, curr) {
        if (prev is MonitorConnected && curr is MonitorConnected) {
          // Only rebuild if the chart index OR data changes
          return prev.currentChartIndex != curr.currentChartIndex ||
              prev.currentVitals != curr.currentVitals;
        }
        return prev.runtimeType != curr.runtimeType;
      },
      builder: (context, state) {
        final isConnected = state is MonitorConnected;
        final currentIndex = isConnected ? state.currentChartIndex : 0;
        final ecgData = isConnected ? state.currentVitals.ecg : <double>[];
        final livePressureData = isConnected
            ? state.currentVitals.livePressure
            : <double>[];

        // Ensure PageController is in sync with state index (e.g. if changed from elsewhere)
        if (_pageController.hasClients &&
            _pageController.page?.round() != currentIndex) {
          _pageController.animateToPage(
            currentIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }

        final bool isPressureChart = currentIndex == 0;
        final String title = isPressureChart
            ? AppStrings.liveBloodPressure
            : AppStrings.ecgWaveform;
        final Color themeColor = isPressureChart
            ? AppColors.bpAmber
            : AppColors.ecgGreen;

        return Column(
          children: [
            // ── Dynamic Header ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 24,
                    decoration: BoxDecoration(
                      color: themeColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      title,
                      key: ValueKey(title),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: themeColor,
                      ),
                    ),
                  ),
                  Spacer(),
                  Icon(
                    isPressureChart
                        ? Icons.bloodtype_outlined
                        : Icons.monitor_heart_outlined,
                    color: themeColor.withValues(alpha: 0.7),
                    size: 20,
                  ),
                ],
              ),
            ),

            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  context.read<MonitorCubit>().changeChart(index);
                },
                children: [
                  BpChartCardWidget(
                    isConnected: isConnected,
                    livePressureData: livePressureData,
                  ),
                  EcgChartCardWidget(
                    isConnected: isConnected,
                    ecgData: ecgData,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(2, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: currentIndex == index ? 24 : 8,
                  decoration: BoxDecoration(
                    color: currentIndex == index
                        ? (index == 0 ? AppColors.bpAmber : AppColors.ecgGreen)
                        : AppColors.lightCardBorder,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ],
        );
      },
    );
  }
}
