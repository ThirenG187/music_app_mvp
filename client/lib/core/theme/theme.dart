import 'package:client/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static final darkThemeMode = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Pallete.backgroundColor,
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(27),
      enabledBorder: _buildOutlineInputBorder(Pallete.borderColor),
      focusedBorder: _buildOutlineInputBorder(Pallete.gradient2),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Pallete.backgroundColor,
    ),
  );

  static OutlineInputBorder _buildOutlineInputBorder(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: color,
        width: 3,
      ),
      borderRadius: BorderRadius.circular(10),
    );
  }
}
