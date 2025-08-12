import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:nava_demon_lords_diary/theme/app_theme.dart';

class AnimatedManaOrb extends StatefulWidget {
  final double value; // 0..1
  const AnimatedManaOrb({super.key, required this.value});

  @override
  State<AnimatedManaOrb> createState() => _AnimatedManaOrbState();
}

class _AnimatedManaOrbState extends State<AnimatedManaOrb>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: const Duration(seconds: 4))
        ..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        final glow = 0.4 + 0.6 * (0.5 + 0.5 * math.sin(t * math.pi * 2));
        return CustomPaint(
          painter: _OrbPainter(intensity: glow * widget.value),
          child: const SizedBox(width: 200, height: 200),
        );
      },
    );
  }
}

class _OrbPainter extends CustomPainter {
  final double intensity;
  _OrbPainter({required this.intensity});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2;

    final base = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.manaTeal.withOpacity(0.9),
          AppColors.arcaneBlue.withOpacity(0.5),
          Colors.transparent,
        ],
        stops: const [0.0, 0.6, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    final glow = Paint()
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 40 * intensity)
      ..color = AppColors.manaTeal.withOpacity(0.7 * intensity);

    canvas.drawCircle(center, radius * 0.86, base);
    canvas.drawCircle(center, radius * 0.7, glow);
  }

  @override
  bool shouldRepaint(covariant _OrbPainter oldDelegate) {
    return oldDelegate.intensity != intensity;
  }
}
