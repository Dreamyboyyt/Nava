import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nava_demon_lords_diary/theme/app_theme.dart';

class GradientScaffold extends StatelessWidget {
  final Widget child;
  final String currentRoute;
  const GradientScaffold({super.key, required this.child, required this.currentRoute});

  int get _index => switch (currentRoute) {
        '/conquests' => 0,
        '/mana' => 1,
        '/grimoire' => 2,
        _ => 0,
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.0, -0.6),
                radius: 1.2,
                colors: [
                  Color(0x330FF0C6),
                  AppColors.voidBlack,
                ],
              ),
            ),
          ),
          child,
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) {
          switch (i) {
            case 0:
              context.go('/conquests');
              break;
            case 1:
              context.go('/mana');
              break;
            case 2:
              context.go('/grimoire');
              break;
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.auto_awesome), label: 'Conquests'),
          NavigationDestination(icon: Icon(Icons.bubble_chart_rounded), label: 'Mana'),
          NavigationDestination(icon: Icon(Icons.menu_book_rounded), label: 'Grimoire'),
        ],
      ),
    );
  }
}
