import 'package:flutter/material.dart';

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
    final theme = Theme.of(context);

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
            label: Text(isMeasuring ? 'Stop' : 'Start'),
            style: ElevatedButton.styleFrom(
              backgroundColor: isMeasuring
                  ? theme.colorScheme.error
                  : theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
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
            label: Text(isSaving ? 'Saving…' : 'Save'),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.secondary,
              foregroundColor: theme.colorScheme.onSecondary,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }
}
