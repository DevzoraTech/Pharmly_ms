import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF0B3C32); // Deep green
  static const Color accentColor = Color(0xFFB6F09C); // Light green
  static const Color backgroundColor = Color(0xFFF8FAFB); // Light background
  static const Color sidebarColor = Color(0xFF163D35); // Sidebar dark green
  static const Color yellow = Color(0xFFFFF6B2); // Soft yellow
  static const Color orange = Color(0xFFFF7A00); // Orange for highlights
  static const Color black = Color(0xFF222B45);
  static const Color white = Colors.white;
  static const Color grey = Color(0xFFBFC9D1);

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    fontFamily: 'Inter',
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: accentColor,
      surface: backgroundColor,
      surfaceTint: white,
      onPrimary: white,
      onSecondary: black,
      onSurface: black,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: white,
      elevation: 0,
      iconTheme: IconThemeData(color: primaryColor),
      titleTextStyle: TextStyle(
        color: primaryColor,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: black,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: black,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: black,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: black),
      bodyMedium: TextStyle(fontSize: 14, color: black),
      labelLarge: TextStyle(fontSize: 14, color: grey),
    ),
    cardColor: white,
    dividerColor: grey,
    iconTheme: const IconThemeData(color: primaryColor),
    buttonTheme: const ButtonThemeData(buttonColor: accentColor),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: sidebarColor,
    scaffoldBackgroundColor: black,
    fontFamily: 'Inter',
    colorScheme: ColorScheme.dark(
      primary: sidebarColor,
      secondary: accentColor,
      surface: black,
      surfaceTint: sidebarColor,
      onPrimary: white,
      onSecondary: black,
      onSurface: white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: sidebarColor,
      elevation: 0,
      iconTheme: IconThemeData(color: white),
      titleTextStyle: TextStyle(
        color: white,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: white,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: white,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: white,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: white),
      bodyMedium: TextStyle(fontSize: 14, color: white),
      labelLarge: TextStyle(fontSize: 14, color: grey),
    ),
    cardColor: sidebarColor,
    dividerColor: grey,
    iconTheme: const IconThemeData(color: accentColor),
    buttonTheme: const ButtonThemeData(buttonColor: accentColor),
  );
}
