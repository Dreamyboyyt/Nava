import 'package:flutter/material.dart';

class AppColors {
  static const Color abyss = Color(0xFF0B0E12);
  static const Color voidBlack = Color(0xFF050608);
  static const Color demonPink = Color(0xFFFF4DA6);
  static const Color arcaneBlue = Color(0xFF55C1FF);
  static const Color manaTeal = Color(0xFF0FF0C6);
  static const Color emberOrange = Color(0xFFFF7A45);
  static const Color slate = Color(0xFF3A4048);
}

class AppTheme {
  static ThemeData abyss() {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.voidBlack,
      colorScheme: base.colorScheme.copyWith(
        brightness: Brightness.dark,
        primary: AppColors.demonPink,
        secondary: AppColors.arcaneBlue,
        surface: AppColors.abyss,
        onSurface: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      textTheme: base.textTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.abyss.withOpacity(0.6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.slate),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.slate),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.demonPink, width: 2),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.abyss.withOpacity(0.6),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  static ThemeData neonArcana() {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: const Color(0xFF0A0D10),
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.manaTeal,
        secondary: AppColors.arcaneBlue,
        surface: const Color(0xFF0E1319),
        onSurface: Colors.white,
      ),
      textTheme: base.textTheme.apply(bodyColor: Colors.white),
      cardTheme: CardThemeData(
        color: const Color(0xFF0E1319).withOpacity(0.7),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  static ThemeData crimsonEmber() {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: const Color(0xFF120808),
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.emberOrange,
        secondary: AppColors.demonPink,
        surface: const Color(0xFF1A0E0E),
        onSurface: Colors.white,
      ),
      textTheme: base.textTheme.apply(bodyColor: Colors.white),
      cardTheme: CardThemeData(
        color: const Color(0xFF1A0E0E).withOpacity(0.7),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
