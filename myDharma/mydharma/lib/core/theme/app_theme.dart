import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

abstract final class AppTheme {
  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.card,
      ),
    );

    final textTheme = GoogleFonts.playfairDisplayTextTheme(base.textTheme).copyWith(
      displaySmall: GoogleFonts.playfairDisplay(
        fontSize: 40,
        height: 1,
        fontWeight: FontWeight.w700,
        color: AppColors.primaryText,
      ),
      headlineMedium: GoogleFonts.playfairDisplay(
        fontSize: 30,
        height: 1.06,
        fontWeight: FontWeight.w700,
        color: AppColors.primaryText,
      ),
      titleLarge: GoogleFonts.playfairDisplay(
        fontSize: 24,
        height: 1.1,
        fontWeight: FontWeight.w700,
        color: AppColors.primaryText,
      ),
      titleMedium: GoogleFonts.playfairDisplay(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.primaryText,
      ),
      bodyMedium: GoogleFonts.playfairDisplay(
        fontSize: 14,
        height: 1.45,
        color: AppColors.muted,
      ),
      labelLarge: GoogleFonts.playfairDisplay(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
      ),
    );

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.cream,
      textTheme: textTheme,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.ink,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.card,
        indicatorColor: AppColors.accentSoft,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => GoogleFonts.playfairDisplay(
            fontSize: 11,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
            color: states.contains(WidgetState.selected)
                ? AppColors.primary
                : AppColors.muted,
          ),
        ),
      ),
    );
  }
}
