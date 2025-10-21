import 'dart:math';
import 'package:flutter/material.dart';

class StarBackground extends StatefulWidget {
  final int starCount;

  const StarBackground({super.key, this.starCount = 100});

  @override
  State<StarBackground> createState() => _StarBackgroundState();
}

class _StarBackgroundState extends State<StarBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Star> _stars = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _generateStars();
  }

  void _generateStars() {
    for (int i = 0; i < widget.starCount; i++) {
      _stars.add(
        Star(
          x: _random.nextDouble(),
          y: _random.nextDouble(),
          size: _random.nextDouble() * 2 + 0.5, // Size between 0.5 and 2.5
          opacity: _random.nextDouble() * 0.7 + 0.3, // Opacity between 0.3 and 1.0
          twinkleSpeed: _random.nextDouble() * 4 + 1, // Speed between 1 and 5
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: StarPainter(stars: _stars, animation: _controller.value),
          );
        },
      ),
    );
  }
}

class StarPainter extends CustomPainter {
  final List<Star> stars;
  final double animation;

  StarPainter({required this.stars, required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    for (var star in stars) {
      // Calculate star position and opacity based on animation
      final x = star.x * size.width;
      final y = star.y * size.height;
      
      // Calculate twinkling effect
      final twinklePhase = (animation * star.twinkleSpeed) % 1.0;
      final twinkleValue = sin(twinklePhase * 2 * pi) * 0.4 + 0.6; // Varies between 0.2 and 1.0
      
      final paint = Paint()
        ..color = Colors.white.withOpacity(star.opacity * twinkleValue)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(x, y), star.size, paint);
    }
  }

  @override
  bool shouldRepaint(StarPainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}

class Star {
  final double x;
  final double y;
  final double size;
  final double opacity;
  final double twinkleSpeed;

  Star({
    required this.x,
    required this.y,
    required this.size,
    required this.opacity,
    required this.twinkleSpeed,
  });
}
