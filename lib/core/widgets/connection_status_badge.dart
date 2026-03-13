import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum ConnectionStatus {
  connected,
  connecting,
  disconnected,
}

class ConnectionStatusBadge extends StatelessWidget {
  final ConnectionStatus status;
  final String label;
  final IconData? icon;
  final double fontSize;
  final double dotSize;

  const ConnectionStatusBadge({
    super.key,
    required this.status,
    required this.label,
    this.icon,
    this.fontSize = 10,
    this.dotSize = 6,
  });

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      ConnectionStatus.connected => AppColors.ecgGreen,
      ConnectionStatus.connecting => AppColors.bpAmber,
      ConnectionStatus.disconnected => AppColors.heartRateRed,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _PulsingDot(
            color: color,
            size: dotSize,
            isPulsing: status != ConnectionStatus.disconnected,
          ),
          const SizedBox(width: 8),
          if (icon != null) ...[
            Icon(icon, size: fontSize + 1, color: color.withValues(alpha: 0.9)),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: color.withValues(alpha: 0.9),
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _PulsingDot extends StatefulWidget {
  final Color color;
  final double size;
  final bool isPulsing;

  const _PulsingDot({
    required this.color,
    required this.size,
    this.isPulsing = true,
  });

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    
    if (widget.isPulsing) {
      _controller.repeat(reverse: true);
    }

    _animation = Tween<double>(
      begin: 0.4,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(covariant _PulsingDot oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPulsing && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.isPulsing && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, _) => Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: widget.color.withValues(
            alpha: widget.isPulsing ? _animation.value : 1.0,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: widget.color.withValues(
                alpha: (widget.isPulsing ? _animation.value : 1.0) * 0.5,
              ),
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
        ),
      ),
    );
  }
}
