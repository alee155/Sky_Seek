import 'dart:math';
import 'package:flutter/material.dart';

class ShootingStarField extends StatefulWidget {
  final int starCount;
  final double opacity;

  const ShootingStarField({super.key, this.starCount = 5, this.opacity = 1.0});

  @override
  State<ShootingStarField> createState() => _ShootingStarFieldState();
}

class _ShootingStarFieldState extends State<ShootingStarField>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<ShootingStar> _shootingStars = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _generateShootingStars();
  }

  void _generateShootingStars() {
    for (int i = 0; i < widget.starCount; i++) {
      _shootingStars.add(
        ShootingStar(
          startX: _random.nextDouble() * 1.5 - 0.2, // Start slightly off-screen
          startY: _random.nextDouble() * 0.5, // Start from top half
          length:
              _random.nextDouble() * 0.3 + 0.1, // Length between 0.1 and 0.4
          angle:
              _random.nextDouble() * 0.4 +
              0.2, // Angle between 0.2 and 0.6 radians
          speed: _random.nextDouble() * 0.8 + 0.4, // Speed between 0.4 and 1.2
          delay: _random.nextDouble(), // Random start time
          thickness: _random.nextDouble() * 1.5 + 1.0, // Line thickness
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
            painter: ShootingStarPainter(
              shootingStars: _shootingStars,
              animation: _controller.value,
              opacity: widget.opacity,
            ),
          );
        },
      ),
    );
  }
}

class ShootingStarPainter extends CustomPainter {
  final List<ShootingStar> shootingStars;
  final double animation;
  final double opacity;

  ShootingStarPainter({
    required this.shootingStars,
    required this.animation,
    this.opacity = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    for (var star in shootingStars) {
      // Calculate timing with delay
      final cyclePosition = (animation + star.delay) % 1.0;

      // Only draw if star is in its active phase (30% of the cycle)
      if (cyclePosition < 0.3) {
        final progress =
            cyclePosition / 0.3; // Normalize to 0-1 within the active phase

        // Calculate start and end positions
        final startX = star.startX * width;
        final startY = star.startY * height;

        // Calculate the end point based on angle and length
        final endX = startX + cos(star.angle) * star.length * width * progress;
        final endY = startY + sin(star.angle) * star.length * height * progress;

        // Create a gradient for the trail
        final gradient = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(opacity),
            Colors.white.withOpacity(0.8 * opacity),
            Colors.white.withOpacity(0.0),
          ],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(
          Rect.fromPoints(Offset(startX, startY), Offset(endX, endY)),
        );

        final paint =
            Paint()
              ..shader = gradient
              ..strokeWidth = star.thickness
              ..strokeCap = StrokeCap.round
              ..style = PaintingStyle.stroke;

        // Draw the shooting star trail
        canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);

        // Draw a brighter point at the leading edge
        final headPaint =
            Paint()
              ..color = Colors.white.withOpacity(opacity)
              ..style = PaintingStyle.fill;

        canvas.drawCircle(Offset(endX, endY), star.thickness * 1.5, headPaint);
      }
    }
  }

  @override
  bool shouldRepaint(ShootingStarPainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}

class ShootingStar {
  final double startX;
  final double startY;
  final double length;
  final double angle;
  final double speed;
  final double delay;
  final double thickness;

  ShootingStar({
    required this.startX,
    required this.startY,
    required this.length,
    required this.angle,
    required this.speed,
    required this.delay,
    required this.thickness,
  });
}
