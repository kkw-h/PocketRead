import 'package:flutter/material.dart';

final class AppTheme {
  const AppTheme._();

  static ThemeData light() {
    const Color seedColor = Color(0xFF226F54);

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: const Color(0xFFF6F1E9),
      appBarTheme: const AppBarTheme(centerTitle: false),
    );
  }

  static ThemeData dark() {
    const Color seedColor = Color(0xFF95D5B2);

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.dark,
      ),
      appBarTheme: const AppBarTheme(centerTitle: false),
    );
  }
}
