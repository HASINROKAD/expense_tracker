import 'package:expense_tracker/theme/custom_theme/text_theme.dart';
import 'package:expense_tracker/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  /// Light theme configuration
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'lato',
    brightness: Brightness.light,
    primaryColor: TColors.primary,
    scaffoldBackgroundColor: Colors.white,
    textTheme: TTextTheme.lightTextTheme,

    // App Bar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: TColors.primary,
      foregroundColor: TColors.textWhite,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TTextTheme.lightTextTheme.titleLarge?.copyWith(
        color: TColors.textWhite,
        fontWeight: FontWeight.bold,
      ),
    ),

    // Card Theme
    cardTheme: const CardThemeData(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: TColors.primary,
        foregroundColor: TColors.textWhite,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: TColors.containerPrimary),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: TColors.containerPrimary),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: TColors.primary, width: 2),
      ),
      filled: true,
      fillColor: Colors.grey[50],
    ),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: TColors.primary,
      unselectedItemColor: Colors.grey[600],
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
  );

  /// Dark theme configuration
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'lato',
    brightness: Brightness.dark,
    primaryColor: TColors.primaryDark,
    scaffoldBackgroundColor: TColors.backgroundDark,
    canvasColor: TColors.surfaceDark,
    textTheme: TTextTheme.darkTextTheme,

    // Color scheme for dark theme
    colorScheme: const ColorScheme.dark(
      primary: TColors.primaryDark,
      secondary: TColors.secondaryDark,
      surface: TColors.surfaceDark,
      onPrimary: TColors.textWhite,
      onSecondary: TColors.textWhite,
      onSurface: TColors.textPrimaryDark,
      outline: TColors.borderDark,
      surfaceContainerHighest: TColors.surfaceVariantDark,
    ),

    // App Bar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: TColors.primaryDark,
      foregroundColor: TColors.textWhite,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TTextTheme.darkTextTheme.titleLarge?.copyWith(
        color: TColors.textWhite,
        fontWeight: FontWeight.bold,
      ),
    ),

    // Card Theme
    cardTheme: const CardThemeData(
      color: TColors.surfaceDark,
      elevation: 8,
      shadowColor: Colors.black54,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: TColors.primaryDark,
        foregroundColor: TColors.textWhite,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: TColors.borderDark),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: TColors.borderDark),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: TColors.primaryDark, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: TColors.errorPrimaryDark),
      ),
      filled: true,
      fillColor: TColors.containerPrimaryDark,
      hintStyle: const TextStyle(color: TColors.textTertiaryDark),
      labelStyle: const TextStyle(color: TColors.textSecondaryDark),
    ),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: TColors.surfaceDark,
      selectedItemColor: TColors.primaryDark,
      unselectedItemColor: TColors.textTertiaryDark,
      type: BottomNavigationBarType.fixed,
      elevation: 12,
    ),

    // Divider Theme
    dividerTheme: const DividerThemeData(
      color: TColors.dividerDark,
      thickness: 1,
    ),
  );
}
