import 'package:flutter/material.dart';

class AppTheme {
  // Theme Colors (Clean White & Teal)
  static const Color primaryColor = Color(0xFF006064); // Deep Teal
  static const Color secondaryColor = Color(0xFF00838F); // Slightly Lighter Teal
  static const Color backgroundColor = Color(0xFFFFFFFF); // Pure White
  static const Color surfaceColor = Color(0xFFF0F4F4); // Very Light Teal/Gray (Pastel-ish)
  static const Color textPrimaryColor = Color(0xFF1B2C2D); // Dark Slate Black
  static const Color textSecondaryColor = Color(0xFF546E7A); // Muted Blue Gray
  
  static const Color successColor = Color(0xFF4DB6AC); // Soft Teal Green
  static const Color warningColor = Color(0xFFFF8A65); // Soft Deep Orange (Muted)


  // Consistent Corner Radius
  static BorderRadius defaultBorderRadius = BorderRadius.circular(20);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: backgroundColor, // Use White as main background surface
        error: Color(0xFFE57373), // Soft Red
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimaryColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      // Flat, clean card design
      cardTheme: CardThemeData(
        color: surfaceColor, // Light Pastel Surface
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: defaultBorderRadius,
          side: const BorderSide(color: Color(0xFFECEFF1), width: 1), // Subtle light gray border
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: defaultBorderRadius,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        border: OutlineInputBorder(
          borderRadius: defaultBorderRadius,
          borderSide: const BorderSide(color: Color(0xFFECEFF1), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: defaultBorderRadius,
          borderSide: const BorderSide(color: Color(0xFFECEFF1), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: defaultBorderRadius,
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        hintStyle: const TextStyle(color: textSecondaryColor, fontSize: 16),
        labelStyle: const TextStyle(color: textPrimaryColor, fontSize: 16),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: textPrimaryColor),
        displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textPrimaryColor),
        headlineLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: textPrimaryColor),
        headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: textPrimaryColor),
        titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: textPrimaryColor),
        bodyLarge: TextStyle(fontSize: 18, color: textPrimaryColor), // Min 16sp
        bodyMedium: TextStyle(fontSize: 16, color: textPrimaryColor), // Min 16sp
        labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textPrimaryColor),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: textPrimaryColor, size: 28),
        titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textPrimaryColor),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        elevation: 0,
        selectedItemColor: primaryColor,
        unselectedItemColor: textSecondaryColor,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
