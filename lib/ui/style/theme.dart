import 'package:flutter/material.dart';

import 'colors.dart';

class AppTheme {
  static final tema = ThemeData(
    useMaterial3: true,
    fontFamily: 'SUSEMono',
    scaffoldBackgroundColor: AppColors.fundo,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.verde),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.verde,
      foregroundColor: Colors.white,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.verde,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(48),
      ),
    ),
  );
}
