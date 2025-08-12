import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nava_demon_lords_diary/theme/app_theme.dart';

enum ThemeKey { abyss, neon, crimson }

final themeKeyProvider = StateNotifierProvider<ThemeController, ThemeKey>((ref) {
  return ThemeController();
});

final themeDataProvider = Provider<ThemeData>((ref) {
  final key = ref.watch(themeKeyProvider);
  switch (key) {
    case ThemeKey.abyss:
      return AppTheme.abyss();
    case ThemeKey.neon:
      return AppTheme.neonArcana();
    case ThemeKey.crimson:
      return AppTheme.crimsonEmber();
  }
});

class ThemeController extends StateNotifier<ThemeKey> {
  ThemeController() : super(ThemeKey.abyss) {
    _load();
  }

  Future<void> _load() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString('theme_key');
    switch (raw) {
      case 'neon':
        state = ThemeKey.neon;
        break;
      case 'crimson':
        state = ThemeKey.crimson;
        break;
      default:
        state = ThemeKey.abyss;
    }
  }

  Future<void> set(ThemeKey key) async {
    state = key;
    final sp = await SharedPreferences.getInstance();
    await sp.setString('theme_key', switch (key) {
      ThemeKey.abyss => 'abyss',
      ThemeKey.neon => 'neon',
      ThemeKey.crimson => 'crimson',
    });
  }
}
