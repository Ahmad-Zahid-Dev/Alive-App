import 'package:flutter/material.dart';

/// Handy extensions on BuildContext, String, num, etc.
extension BuildContextX on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;
  bool get isTablet => screenWidth >= 600;
  bool get isLandscape =>
      MediaQuery.orientationOf(this) == Orientation.landscape;

  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
}

extension StringX on String {
  bool get isValidEmail =>
      RegExp(r'^[\w.-]+@([\w-]+\.)+[\w-]{2,}$').hasMatch(this);
}
