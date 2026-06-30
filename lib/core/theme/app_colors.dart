import 'package:flutter/material.dart';

/// Single source of truth for all app colors.
class AppColors {
  AppColors._();

  // App color definitions matching design guidelines
  static const Color gradientStart = Color(0xFFBBD500); // #bbd500
  static const Color gradientEnd = Color(0xFF46AF03);   // #46af03

  // Primary green
  static const Color primary = Color(0xFF46AF03);       // #46af03
  static const Color primaryDark = Color(0xFF358C02);
  static const Color primaryLight = Color(0xFFBBD500);

  // Secondary / Yellow
  static const Color secondary = Color(0xFFF6EB00);     // #f6eb00
  static const Color accent = Color(0xFFF6EB00);        // #f6eb00
  static const Color followButton = Color(0xFFF6EB00);   // #f6eb00

  // Surface / Background
  static const Color background = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFF5F5F5);
  static const Color surfaceGrey = Color(0xFFF0F0F0);
  static const Color cardDark = Color(0xFF1A1A1A);

  // Text
  static const Color textPrimary = Color(0xFF111111);
  static const Color textSecondary = Color(0xFF888888);
  static const Color textOnGreen = Color(0xFFFFFFFF);
  static const Color textLink = Color(0xFF46AF03);

  // Misc
  static const Color divider = Color(0xFFE0E0E0);
  static const Color overlay = Color(0x55000000);
  static const Color glassWhite = Color(0x33FFFFFF);
  static const Color glassBorder = Color(0x55FFFFFF);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [gradientStart, gradientEnd],
  );

  static const LinearGradient cardOverlay = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent, Color(0xCC000000)],
  );
}
