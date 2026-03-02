import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

Future<ThemeData> loadCustomTheme({required bool isDark}) async {
  final String path = isDark ? 'assets/themeDark.json' : 'assets/theme.json';
  final themeJson = await loadThemeFromJson(path);

  // Estrai i colori principali dal JSON
  String primaryStr = themeJson['colorScheme']?['primary'] ?? "#ff36618e";
  String onPrimaryStr = themeJson['colorScheme']?['onPrimary'] ?? "#ffffffff";
  String primaryContainerStr = themeJson['colorScheme']?['primaryContainer'] ?? "#ffd1e4ff";
  String backgroundStr = themeJson['colorScheme']?['background'] ?? "#fff8f9ff";
  String surfaceStr = themeJson['colorScheme']?['surface'] ?? "#fff8f9ff";
  String onSurfaceStr = themeJson['colorScheme']?['onSurface'] ?? "#ff191c20";

  // Parsing dei colori
  Color primaryColor = _parseColor(primaryStr);
  Color onPrimaryColor = _parseColor(onPrimaryStr);
  Color primaryContainerColor = _parseColor(primaryContainerStr);
  Color backgroundColor = _parseColor(backgroundStr);
  Color surfaceColor = _parseColor(surfaceStr);
  Color onSurfaceColor = _parseColor(onSurfaceStr);

  // Crea il tema usando i colori estratti
  return ThemeData(
    useMaterial3: true,
    brightness: isDark ? Brightness.dark : Brightness.light,

    colorScheme: isDark
        ? ColorScheme.dark(
      primary: primaryColor,
      onPrimary: onPrimaryColor,
      primaryContainer: primaryContainerColor,
      background: backgroundColor,
      surface: surfaceColor,
      onSurface: onSurfaceColor,
    )
        : ColorScheme.light(
      primary: primaryColor,
      onPrimary: onPrimaryColor,
      primaryContainer: primaryContainerColor,
      background: backgroundColor,
      surface: surfaceColor,
      onSurface: onSurfaceColor,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: onPrimaryColor,
      titleTextStyle: TextStyle(
        color: onPrimaryColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),

    cardTheme: CardTheme(
      color: surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: onPrimaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.symmetric(vertical: 16),
      ),
    ),

    textTheme: TextTheme(
      bodyMedium: TextStyle(color: onSurfaceColor),
    ),

    scaffoldBackgroundColor: backgroundColor,
  );
}

// Funzione per convertire stringhe hex in Color
Color _parseColor(String hexString) {
  final buffer = StringBuffer();
  if (hexString.length == 7 && hexString.startsWith('#')) {
    buffer.write('ff'); // Assicura l'opacità piena se non è specificata
  }
  buffer.write(hexString.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}

// Carica il tema dal file JSON
Future<Map<String, dynamic>> loadThemeFromJson(String assetPath) async {
  final String jsonString = await rootBundle.loadString(assetPath);
  return json.decode(jsonString);
}