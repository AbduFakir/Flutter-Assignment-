import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand — purple/pink
  static const Color primary = Color(0xFFB455A0);
  static const Color primaryLight = Color(0xFFC56BB5);
  static const Color primaryDark = Color(0xFF9A3D8A);

  static const Color accent = Color(0xFFFF6584);
  static const Color accentCyan = Color(0xFF00C9C8);
  static const Color accentPurple = Color(0xFF7B5EA7);

  // Backgrounds — white-based
  static const Color background = Color(0xFFF8F4FB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFF3EEF8);
  static const Color card = Color(0xFFFFFFFF);

  // Text
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B6B8A);
  static const Color textHint = Color(0xFFAAAAAC);

  static const Color divider = Color(0xFFEEE8F4);
  static const Color border = Color(0xFFE8DDEF);

  static const Color success = Color(0xFF4CAF82);
  static const Color error = Color(0xFFFF5252);
  static const Color warning = Color(0xFFFFB74D);

  // Gradients
  static const LinearGradient appBarGradient = LinearGradient(
    colors: [Color(0xFFC56BB5), Color(0xFFB455A0)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFC56BB5), Color(0xFFB455A0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient storyRingGradient = LinearGradient(
    colors: [Color(0xFFC56BB5), Color(0xFFFF6584), Color(0xFFFFB347)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF1E1E2E), Color(0xFF252535)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient postOverlay = LinearGradient(
    colors: [Colors.transparent, Color(0xCC000000)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.45, 1.0],
  );
}
