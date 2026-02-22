import 'package:flutter/material.dart';

class AppTheme {
  static const Color emerald = Color(0xFF10B981);

  static ThemeData dark() {
    const ColorScheme scheme = ColorScheme.dark(
      primary: emerald,
      secondary: Color(0xFF34D399),
      surface: Color(0xFF0B1220),
      error: Color(0xFFEF4444),
    );

    return ThemeData(
      colorScheme: scheme,
      scaffoldBackgroundColor: const Color(0xFF030712),
      appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF111827)),
      cardTheme: const CardTheme(color: Color(0xFF111827)),
      useMaterial3: true,
    );
  }
}
