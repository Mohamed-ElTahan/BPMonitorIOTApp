import 'package:flutter/material.dart';

class AppColors {
  // Common Colors
  static const Color ecgGreen = Color(0xFF00C853);
  static const Color spo2Cyan = Color(0xFF00B0FF);
  static const Color heartRateRed = Color(0xFFFF2A55);
  static const Color bpAmber = Color(0xFFFF9100);

  // Status
  static const Color connected = Colors.green;
  static const Color connecting = Colors.orange;
  static const Color disconnected = Colors.red;

  // Dark Theme Colors (Legacy/Optional)
  static const Color darkScaffoldBackground = Color(0xFF0B0E14);
  static const Color darkCardBackground = Color(0xFF151A25);
  static const Color darkCardBorder = Color(0xFF2A3241);
  static const Color darkTextPrimary = Colors.white;
  static const Color darkTextSecondary = Colors.grey;

  // Light Theme Colors
  static const Color lightScaffoldBackground = Color(
    0xFFF7F9FC,
  ); // Light grayish blue
  static const Color lightCardBackground = Colors.white;
  static const Color lightCardBorder = Color(
    0xFFE2E8F0,
  ); // Slate 200 equivalent
  static const Color lightTextPrimary = Color(0xFF1E293B); // Slate 800
  static const Color lightTextSecondary = Color(0xFF64748B); // Slate 500
}
