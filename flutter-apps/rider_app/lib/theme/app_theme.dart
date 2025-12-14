import 'package:flutter/material.dart';

class AppTheme {
  // Color palette based on FireCrawl design
  static const Color primaryColor = Color(0xFF60A5FA); // Blue
  static const Color secondaryColor = Color(0xFFDB2777); // Pink
  static const Color accentColor = Color(0xFF9D174D); // Dark Pink
  static const Color backgroundColor = Color(0xFF0F172A); // Dark Blue
  static const Color surfaceColor = Color(0xFF1E293B); // Slightly lighter dark
  static const Color textColor = Colors.white;
  static const Color textSecondaryColor = Color(0xFF94A3B8); // Gray
  static const Color successColor = Color(0xFF10B981); // Green
  static const Color warningColor = Color(0xFFF59E0B); // Yellow
  static const Color errorColor = Color(0xFFEF4444); // Red

  // Gradient colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF9D174D), Color(0xFF2563EB)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFFDB2777), Color(0xFF60A5FA)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // Dark theme
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: surfaceColor,
      background: backgroundColor,
      error: errorColor,
    ),
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundColor,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: textColor),
      titleTextStyle: TextStyle(
        color: textColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: textColor, fontSize: 32, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(color: textColor, fontSize: 28, fontWeight: FontWeight.bold),
      displaySmall: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(color: textColor, fontSize: 16),
      bodyMedium: TextStyle(color: textSecondaryColor, fontSize: 14),
      labelLarge: TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.bold),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF334155), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      labelStyle: const TextStyle(color: textSecondaryColor),
      hintStyle: const TextStyle(color: textSecondaryColor),
      prefixIconColor: textSecondaryColor,
      suffixIconColor: textSecondaryColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        elevation: 0,
        minimumSize: const Size(double.infinity, 50),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: textColor,
        side: const BorderSide(color: primaryColor, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        minimumSize: const Size(double.infinity, 50),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: backgroundColor,
      selectedItemColor: primaryColor,
      unselectedItemColor: textSecondaryColor,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFF334155),
      thickness: 1,
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: surfaceColor,
      contentTextStyle: TextStyle(color: textColor),
      actionTextColor: primaryColor,
    ),
  );

  // Light theme (optional)
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColor,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
    ),
  );

  // Text styles for gradients
  static const TextStyle gradientTitleStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle gradientSubtitleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  // Card shadows (neomorphic style)
  static const BoxShadow neomorphicShadow = BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 16,
    offset: Offset(8, 8),
  );

  static const BoxShadow neomorphicInnerShadow = BoxShadow(
    color: Color(0x1AFFFFFF),
    blurRadius: 16,
    offset: Offset(-8, -8),
  );

  static BoxDecoration get neomorphicCardDecoration => BoxDecoration(
    color: surfaceColor,
    borderRadius: BorderRadius.circular(16),
    boxShadow: const [
      neomorphicShadow,
      neomorphicInnerShadow,
    ],
  );

  static BoxDecoration get gradientCardDecoration => BoxDecoration(
    gradient: primaryGradient,
    borderRadius: BorderRadius.circular(16),
    boxShadow: const [
      BoxShadow(
        color: Color(0x3360A5FA),
        blurRadius: 20,
        offset: Offset(0, 10),
      ),
    ],
  );
}