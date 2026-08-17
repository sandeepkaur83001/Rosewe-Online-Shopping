import 'dart:math' as math;
import 'package:flutter/material.dart';

class CircularDotLoader extends StatefulWidget {
  final String label;
  final double size;
  final Color dotColor;
  final Color backgroundColor;

  const CircularDotLoader({
    super.key,
    required this.label,
    this.size = 120,
    this.dotColor = Colors.white,
    this.backgroundColor = const Color(0xFF424242),
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
      duration: const Duration(milliseconds: 1500),
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
        color: widget.backgroundColor ?? Colors.black.withAlpha(10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  painter: _CircularDotsPainter(
                    progress: _controller.value,
                    color: widget.dotColor,
                  ),
                );
              },
            ),
          ),
          if (widget.label.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              widget.label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CircularDotsPainter extends CustomPainter {
  final double progress;
  final Color color;

  _CircularDotsPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const int dotCount = 12;

    for (int i = 0; i < dotCount; i++) {
      // Calculate angle for each dot
      final angle = (2 * math.pi * i / dotCount) - (math.pi / 2);
      
      // Calculate opacity based on progress and dot position
      // This creates the "chasing" effect
      double dotProgress = (progress * dotCount - i) % dotCount;
      if (dotProgress < 0) dotProgress += dotCount;
      
      final double opacity = math.max(0.1, 1.0 - (dotProgress / (dotCount * 0.8)));

      final paint = Paint()
        ..color = color.withOpacity(opacity)
        ..style = PaintingStyle.fill;

      // Position of the dot
      final dx = center.dx + radius * math.cos(angle);
      final dy = center.dy + radius * math.sin(angle);

      // Draw rectangular dots like in the image
      const double dotSize = 4.5;
      
      canvas.save();
      canvas.translate(dx, dy);
      canvas.rotate(angle);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset.zero, width: dotSize * 1.8, height: dotSize),
          const Radius.circular(1),
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _CircularDotsPainter oldDelegate) => 
      oldDelegate.progress != progress;
}
