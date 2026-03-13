import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';

class MonitorControlsWidget extends StatelessWidget {
  final bool isConnected;
  final bool isMeasuring;
  final bool isSaving;
  final VoidCallback? onStart;
  final VoidCallback? onStop;
  final VoidCallback? onSave;

  const MonitorControlsWidget({
    super.key,
    required this.isConnected,
    this.isMeasuring = false,
    this.isSaving = false,
    this.onStart,
    this.onStop,
    this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    // Disable all controls while not connected or while saving.
    final controlsEnabled = isConnected && !isSaving;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // ── Start / Stop toggle ──────────────────────────────────────────
        Expanded(
          child: ElevatedButton.icon(
            onPressed: controlsEnabled
                ? (isMeasuring ? onStop : onStart)
                : null,
            icon: Icon(isMeasuring ? Icons.stop : Icons.play_arrow),
            label: Text(isMeasuring ? AppStrings.stop : AppStrings.start),
            style: ElevatedButton.styleFrom(
              backgroundColor: isMeasuring
                  ? AppColors.heartRateRed
                  : AppColors.ecgGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),

        const SizedBox(width: 12),

        // ── Save ─────────────────────────────────────────────────────────
        Expanded(
          child: ElevatedButton.icon(
            onPressed: controlsEnabled ? onSave : null,
            icon: isSaving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.save),
            label: Text(isSaving ? AppStrings.saving : AppStrings.save),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.spo2Cyan,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }
}
