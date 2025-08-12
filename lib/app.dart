import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nava_demon_lords_diary/theme/app_theme.dart';
import 'package:nava_demon_lords_diary/common/widgets/gradient_scaffold.dart';
import 'package:nava_demon_lords_diary/features/conquests/presentation/conquests_screen.dart';
import 'package:nava_demon_lords_diary/features/mood/presentation/mood_screen.dart';
import 'package:nava_demon_lords_diary/features/grimoire/presentation/grimoire_screen.dart';
import 'package:nava_demon_lords_diary/features/settings/presentation/settings_screen.dart';
import 'package:nava_demon_lords_diary/features/settings/theme_controller.dart';

class NavaApp extends ConsumerWidget {
  const NavaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeDataProvider);
    final router = _createRouter();
    return MaterialApp.router(
      title: 'Nava',
      theme: theme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }

  GoRouter _createRouter() {
    return GoRouter(
      initialLocation: '/conquests',
      routes: [
        ShellRoute(
          builder: (context, state, child) => GradientScaffold(
            child: child,
            currentRoute: state.matchedLocation,
          ),
          routes: [
            GoRoute(
              path: '/conquests',
              name: 'conquests',
              builder: (context, state) => const ConquestsScreen(),
            ),
            GoRoute(
              path: '/mana',
              name: 'mana',
              builder: (context, state) => const MoodScreen(),
            ),
            GoRoute(
              path: '/grimoire',
              name: 'grimoire',
              builder: (context, state) => const GrimoireScreen(),
            ),
            GoRoute(
              path: '/settings',
              name: 'settings',
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    );
  }
}
