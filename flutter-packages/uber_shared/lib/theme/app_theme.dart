import 'package:flutter/material.dart';

/// AppTheme defines the neomorphic design theme for the Uber Clone application
/// with beautiful gradients, shadow effects, and smooth animations.
class AppTheme {
  // Primary colors with gradient effect
  static const Color primaryLight = Color(0xFF6C63FF);
  static const Color primaryDark = Color(0xFF4A44B5);
  
  // Accent colors for highlights and special elements
  static const Color accentStart = Color(0xFFFF6584);
  static const Color accentEnd = Color(0xFFFF8E53);
  
  // Neomorphic shadow colors
  static const Color shadowLight = Color(0xFFFFFFFF);
  static const Color shadowDark = Color(0xFFD1CDC7);
  
  // Background and surface colors
  static const Color backgroundColor = Color(0xFFE0E0E0);
  static const Color surfaceColor = Color(0xFFF0F0F0);
  
  // Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);
  
  // Additional status colors for backward compatibility
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFFC107);
  static const Color errorColor = Color(0xFFF44336);
  static const Color infoColor = Color(0xFF2196F3);
  static const Color primaryColor = primaryLight;
  static const Color secondaryColor = Color(0xFF9E9E9E);
  static const Color textPrimaryColor = textPrimary;
  static const Color textSecondaryColor = textSecondary;
  
  // Neutral colors
  static const Color neutralLight = Color(0xFFFAFAFA);
  static const Color neutral = Color(0xFF9E9E9E);
  static const Color neutralDark = Color(0xFF616161);
  
  // Text colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  
  /// Creates the base ThemeData with neomorphic styling
  static ThemeData get theme {
    return ThemeData(
      primaryColor: primaryLight,
      scaffoldBackgroundColor: backgroundColor,
      fontFamily: 'Roboto',
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        headlineSmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textSecondary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: textPrimary,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          color: textSecondary,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
      ),
    );
  }
  
  /// Linear gradient for primary elements
  static LinearGradient primaryGradient = LinearGradient(
    colors: [primaryLight, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  /// Linear gradient for accent elements
  static LinearGradient accentGradient = LinearGradient(
    colors: [accentStart, accentEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}