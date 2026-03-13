import 'package:flutter/material.dart';

extension ResponsiveContext on BuildContext {
  /// Returns the screen width.
  double get width => MediaQuery.of(this).size.width;

  /// Returns the screen height.
  double get height => MediaQuery.of(this).size.height;

  /// Returns the screen padding (e.g., status bar, notches).
  EdgeInsets get padding => MediaQuery.of(this).padding;

  /// Returns the view insets (e.g., keyboard height).
  EdgeInsets get viewInsets => MediaQuery.of(this).viewInsets;

  /// Reusable responsive function to return values based on screen width.
  /// 
  /// Provide values for: [mobile] and optional [tablet].
  T responsive<T>({
    required T mobile,
    T? tablet,
    double tabletBreakpoint = 600,
  }) {
    final screenWidth = width;
    if (screenWidth >= tabletBreakpoint && tablet != null) {
      return tablet;
    }
    return mobile;
  }
}
