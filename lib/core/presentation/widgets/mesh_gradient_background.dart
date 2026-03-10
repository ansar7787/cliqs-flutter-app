import 'dart:math' as math;
import 'package:flutter/material.dart';

class MeshGradientBackground extends StatefulWidget {
  const MeshGradientBackground({super.key});

  @override
  State<MeshGradientBackground> createState() => _MeshGradientBackgroundState();
}

class _MeshGradientBackgroundState extends State<MeshGradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _MeshPainter(_controller.value),
          child: Container(),
        );
      },
    );
  }
}

class _MeshPainter extends CustomPainter {
  final double progress;
  _MeshPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 50);

    // Color Palette
    final colors = [
      const Color(0xFF2563EB).withValues(alpha: 0.15), // Primary Blue
      const Color(0xFF7C3AED).withValues(alpha: 0.12), // Violet
      const Color(0xFF3B82F6).withValues(alpha: 0.1), // Sky Blue
      const Color(0xFF6366F1).withValues(alpha: 0.08), // Indigo
    ];

    for (var i = 0; i < colors.length; i++) {
      final angle = (progress * 2 * math.pi) + (i * math.pi / 2);
      final radius = size.width * 0.4;

      final x =
          size.width / 2 +
          math.cos(angle) * radius * math.sin(progress * 2 * math.pi + i);
      final y =
          size.height / 2 +
          math.sin(angle) * radius * math.cos(progress * 2 * math.pi + i);

      paint.color = colors[i];
      canvas.drawCircle(
        Offset(x, y),
        radius * (1.2 + 0.3 * math.sin(progress * math.pi)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _MeshPainter oldDelegate) => true;
}
