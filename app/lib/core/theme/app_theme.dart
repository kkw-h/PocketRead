import 'package:flutter/material.dart';

final class AppTheme {
  const AppTheme._();

  static ThemeData light() {
    const Color background = Color(0xFFFDF9F0);
    const Color surface = Color(0xFFF6F2E9);
    const Color primary = Color(0xFF5C432A);
    const Color secondary = Color(0xFF7D8F69);
    const Color text = Color(0xFF3E2C1C);
    const Color heading = Color(0xFF1C1C1C);
    const Color outline = Color(0xFFE7DECF);

    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: primary,
        onPrimary: Color(0xFFFFFFFF),
        secondary: secondary,
        onSecondary: Color(0xFFFFFFFF),
        error: Color(0xFFB3261E),
        onError: Color(0xFFFFFFFF),
        surface: surface,
        onSurface: text,
      ),
      scaffoldBackgroundColor: background,
      fontFamily: 'SF Pro Text',
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w700,
          color: heading,
          letterSpacing: -0.5,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: heading,
        ),
        titleMedium: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: heading,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          height: 1.45,
          color: text,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          height: 1.4,
          color: text,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          height: 1.35,
          color: Color(0xFF8D7B6A),
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF8D7B6A),
        ),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        backgroundColor: background,
        foregroundColor: heading,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFFFFFFFF),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: outline),
        ),
        margin: EdgeInsets.zero,
      ),
      iconTheme: const IconThemeData(color: heading),
      dividerColor: outline,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFFFFFFF),
        hintStyle: const TextStyle(
          color: Color(0xFFAA9A8A),
          fontSize: 14,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primary, width: 1.2),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFFE8F3E3),
        selectedColor: const Color(0xFFE8F3E3),
        disabledColor: const Color(0xFFE8F3E3),
        labelStyle: const TextStyle(
          color: Color(0xFF4B7255),
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          minimumSize: const Size.fromHeight(52),
        ),
      ),
    );
  }

  static ThemeData dark() {
    const Color background = Color(0xFF1E1E1E);
    const Color surface = Color(0xFF2C2C2C);
    const Color primary = Color(0xFF70AFFF);
    const Color secondary = Color(0xFF95B39C);
    const Color text = Color(0xFFE0E0E0);
    const Color heading = Color(0xFFFFFFFF);
    const Color outline = Color(0xFF3A3A3A);

    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: primary,
        onPrimary: Color(0xFF0B1A2D),
        secondary: secondary,
        onSecondary: Color(0xFF07110A),
        error: Color(0xFFF2B8B5),
        onError: Color(0xFF601410),
        surface: surface,
        onSurface: text,
      ),
      scaffoldBackgroundColor: background,
      fontFamily: 'SF Pro Text',
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w700,
          color: heading,
          letterSpacing: -0.5,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: heading,
        ),
        titleMedium: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: heading,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          height: 1.45,
          color: text,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          height: 1.4,
          color: text,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          height: 1.35,
          color: Color(0xFFA7A7A7),
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFFA7A7A7),
        ),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        backgroundColor: background,
        foregroundColor: heading,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF262626),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: outline),
        ),
        margin: EdgeInsets.zero,
      ),
      iconTheme: const IconThemeData(color: heading),
      dividerColor: outline,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2B2B2B),
        hintStyle: const TextStyle(
          color: Color(0xFF909090),
          fontSize: 14,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primary, width: 1.2),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFF263A2D),
        selectedColor: const Color(0xFF263A2D),
        disabledColor: const Color(0xFF263A2D),
        labelStyle: const TextStyle(
          color: Color(0xFFC4E5C6),
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: const Color(0xFF0B1A2D),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          minimumSize: const Size.fromHeight(52),
        ),
      ),
    );
  }
}
