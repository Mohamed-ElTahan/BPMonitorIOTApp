import 'package:flutter/material.dart';
import '../../core/extensions/context_extension.dart';
import 'widgets/about_app_header.dart';
import 'widgets/about_description_section.dart';
import 'widgets/about_navigation_group.dart';
import 'widgets/about_copyright_footer.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    // Start the entrance animation after a short delay
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _isVisible = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = context.responsive(mobile: 24.0, tablet: 48.0);

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.only(
        left: horizontalPadding,
        right: horizontalPadding,
        top: context.padding.top + 20,
        bottom: context.padding.bottom + 40,
      ),
      child: Column(
        children: [
          _AnimatedEntrance(
            isVisible: _isVisible,
            delay: const Duration(milliseconds: 0),
            child: const AboutAppHeader(),
          ),
          SizedBox(height: context.responsive(mobile: 12, tablet: 24)),
          _AnimatedEntrance(
            isVisible: _isVisible,
            delay: const Duration(milliseconds: 300),
            child: const AboutDescriptionSection(),
          ),
          SizedBox(height: context.responsive(mobile: 20, tablet: 40)),
          _AnimatedEntrance(
            isVisible: _isVisible,
            delay: const Duration(milliseconds: 600),
            child: const AboutNavigationGroup(),
          ),
          SizedBox(height: context.responsive(mobile: 24, tablet: 48)),
          _AnimatedEntrance(
            isVisible: _isVisible,
            delay: const Duration(milliseconds: 900),
            child: const AboutCopyrightFooter(),
          ),
        ],
      ),
    );
  }
}

class _AnimatedEntrance extends StatelessWidget {
  final Widget child;
  final bool isVisible;
  final Duration delay;

  const _AnimatedEntrance({
    required this.child,
    required this.isVisible,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOut,
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.only(top: isVisible ? 0 : 40),
        child: child,
      ),
    );
  }
}
