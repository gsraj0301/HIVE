import 'package:flutter/material.dart';

class AppTheme {
  // Dark Purple/Blue Cybersecurity Colors
  static const Color primaryDark = Color(0xFF1A0033); // Deep purple
  static const Color primaryPurple = Color(0xFF6B2FB5); // Vibrant purple
  static const Color accentBlue = Color(0xFF0099FF); // Cyber blue
  static const Color accentCyan = Color(0xFF00FFFF); // Bright cyan
  
  static const Color cardBackground = Color(0xFF2D1B4E); // Dark purple card
  static const Color surfaceDark = Color(0xFF1F0F3D); // Darker surface
  static const Color borderColor = Color(0xFF6B2FB5); // Purple border
  
  // Alert Colors
  static const Color criticalRed = Color(0xFFFF3366); // Scam/Critical
  static const Color warningOrange = Color(0xFFFF9933); // Warning
  static const Color successGreen = Color(0xFF00DD99); // Success
  
  // Gradient Colors
  static const Color gradientStart = Color(0xFF1A0033);
  static const Color gradientEnd = Color(0xFF0A1A33);
  
  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0B0);

  // Aliases for compatibility with screen files
  static const Color darkBackground = primaryDark;
  static const Color cardColor = cardBackground;
  static const Color textColor = textPrimary;

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: primaryDark,
      primaryColor: primaryPurple,
      colorScheme: const ColorScheme.dark(
        primary: primaryPurple,
        secondary: accentBlue,
        tertiary: accentCyan,
        surface: cardBackground,
        error: criticalRed,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryDark,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: accentBlue),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceDark,
        selectedItemColor: accentBlue,
        unselectedItemColor: textSecondary,
        elevation: 8,
      ),
      cardTheme: CardThemeData(
        color: cardBackground,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: borderColor, width: 1),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: textPrimary,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        bodyMedium: TextStyle(
          color: textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        labelSmall: TextStyle(
          color: textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderColor, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: accentBlue, width: 2),
        ),
        hintStyle: const TextStyle(color: textSecondary),
        labelStyle: const TextStyle(color: textPrimary),
        prefixIconColor: accentBlue,
        suffixIconColor: accentBlue,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: cardBackground,
        selectedColor: primaryPurple,
        labelStyle: const TextStyle(color: textPrimary),
        brightness: Brightness.dark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: borderColor, width: 1),
        ),
      ),
      dividerColor: borderColor,
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return accentBlue;
          }
          return textSecondary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return accentBlue.withOpacity(0.3);
          }
          return borderColor.withOpacity(0.3);
        }),
      ),
    );
  }

  // Gradient decoration for glassmorphism effect
  static BoxDecoration get glassmorphicCard {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          cardBackground.withOpacity(0.8),
          surfaceDark.withOpacity(0.6),
        ],
      ),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: borderColor.withOpacity(0.3), width: 1),
      boxShadow: [
        BoxShadow(
          color: primaryPurple.withOpacity(0.2),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  // Gradient for backgrounds
  static BoxDecoration get backgroundGradient {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          primaryDark,
          const Color(0xFF0A1A33),
        ],
      ),
    );
  }
}
