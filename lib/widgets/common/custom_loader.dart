import 'dart:math' as math;
import 'package:flutter/material.dart';


class CircularDotLoader extends StatefulWidget {
  final String label;
  final double size;
  final int dotCount;
  final Color dotColor;
  final Color backgroundColor;
  final TextStyle? labelStyle;
  final Duration duration;

  const CircularDotLoader({
    super.key,
    required this.label,
    this.size = 100,
    this.dotCount = 16,
    this.dotColor = Colors.white,
    this.backgroundColor = const Color(0xFF9E9E9E),
    this.labelStyle,
    this.duration = const Duration(seconds: 2),
  });

  @override
  State<CircularDotLoader> createState() => _CircularDotLoaderState();
}

class _CircularDotLoaderState extends State<CircularDotLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                size: Size(widget.size, widget.size),
                painter: _DotRingPainter(
                  progress: _controller.value,
                  dotCount: widget.dotCount,
                  color: widget.dotColor,
                ),
              );
            },
          ),
          // Center label card
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.20),
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            // child: Text(
            //   widget.label,
            //   style: widget.labelStyle ??
            //       const TextStyle(
            //         fontSize: 16,
            //         fontWeight: FontWeight.w500,
            //         color: Colors.black87,
            //       ),
            // ),
          ),
        ],
      ),
    );
  }
}

class _DotRingPainter extends CustomPainter {
  final double progress; // 0..1, drives rotation
  final int dotCount;
  final Color color;

  _DotRingPainter({
    required this.progress,
    required this.dotCount,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 24; // ring radius, inset from edge

    for (int i = 0; i < dotCount; i++) {
      // Base angle for this dot, plus rotation offset from progress.
      final angle = (2 * math.pi * i / dotCount) + (progress * 2 * math.pi);

      final dx = center.dx + radius * math.cos(angle);
      final dy = center.dy + radius * math.sin(angle);

      // Fade dots based on position around the ring so it looks like
      // a "comet trail" — brightest near the leading edge, fading out.
      final fadePosition = (i / dotCount);
      final opacity = 0.25 + 0.75 * fadePosition;

      // Alternate between diamond and small square shapes.
      final isDiamond = i % 2 == 0;
      final dotSize = 8.0 + (fadePosition * 4.0); // slight size variance

      final paint = Paint()
        ..color = color.withValues(alpha: opacity.clamp(0.0, 1.0))
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(dx, dy);
      canvas.rotate(angle + math.pi / 4); // orient shape outward

      if (isDiamond) {
        _drawDiamond(canvas, paint, dotSize);
      } else {
        _drawSquare(canvas, paint, dotSize * 0.4);
      }

      canvas.restore();
    }
  }

  void _drawDiamond(Canvas canvas, Paint paint, double size) {
    final path = Path()
      ..moveTo(0, -size / 2)
      ..lineTo(size / 2, 0)
      ..lineTo(0, size / 2)
      ..lineTo(-size / 2, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  void _drawSquare(Canvas canvas, Paint paint, double size) {
    canvas.drawRect(
      Rect.fromCenter(center: Offset.zero, width: size, height: size),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _DotRingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
