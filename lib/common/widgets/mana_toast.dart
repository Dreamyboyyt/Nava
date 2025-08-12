import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nava_demon_lords_diary/theme/app_theme.dart';

class ManaToast {
  static Future<void> show(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(milliseconds: 1400),
  }) async {
    final overlay = Overlay.of(context);
    if (overlay == null) return;
    final entry = OverlayEntry(
      builder: (context) {
        return const _ToastLayer();
      },
    );
    final content = OverlayEntry(
      builder: (context) {
        return _ToastWidget(message: message, duration: duration);
      },
    );
    overlay.insert(entry);
    overlay.insert(content);
    await Future<void>.delayed(duration);
    content.remove();
    entry.remove();
  }
}

class _ToastLayer extends StatelessWidget {
  const _ToastLayer();
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment(0, -0.6),
              colors: [Color(0x110FF0C6), Colors.transparent],
            ),
          ),
        ),
      ),
    );
  }
}

class _ToastWidget extends StatefulWidget {
  final String message;
  final Duration duration;
  const _ToastWidget({required this.message, required this.duration});

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 250),
    reverseDuration: const Duration(milliseconds: 250),
  )..forward();

  @override
  void initState() {
    super.initState();
    unawaited(Future<void>.delayed(widget.duration - const Duration(milliseconds: 250))
        .then((_) => mounted ? controller.reverse() : null));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: SafeArea(
          child: AnimatedBuilder(
            animation: controller,
            builder: (context, _) {
              final t = Curves.easeOut.transform(controller.value);
              return Opacity(
                opacity: t,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Transform.translate(
                    offset: Offset(0, (1 - t) * 40),
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.abyss.withOpacity(0.92),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x550FF0C6),
                            blurRadius: 24,
                            spreadRadius: 2,
                          ),
                        ],
                        border: Border.all(color: AppColors.manaTeal.withOpacity(0.6)),
                      ),
                      child: Text(
                        widget.message,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
