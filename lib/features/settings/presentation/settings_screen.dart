import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nava_demon_lords_diary/features/settings/theme_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final key = ref.watch(themeKeyProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const ListTile(title: Text('Theme')),
          RadioListTile<ThemeKey>(
            title: const Text('Abyss'),
            value: ThemeKey.abyss,
            groupValue: key,
            onChanged: (v) => ref.read(themeKeyProvider.notifier).set(v!),
          ),
          RadioListTile<ThemeKey>(
            title: const Text('Neon Arcana'),
            value: ThemeKey.neon,
            groupValue: key,
            onChanged: (v) => ref.read(themeKeyProvider.notifier).set(v!),
          ),
          RadioListTile<ThemeKey>(
            title: const Text('Crimson Ember'),
            value: ThemeKey.crimson,
            groupValue: key,
            onChanged: (v) => ref.read(themeKeyProvider.notifier).set(v!),
          ),
        ],
      ),
    );
  }
}
