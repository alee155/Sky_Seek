import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StarFieldAnimation extends StatefulWidget {
  const StarFieldAnimation({super.key});

  @override
  State<StarFieldAnimation> createState() => _StarFieldAnimationState();
}

class _StarFieldAnimationState extends State<StarFieldAnimation>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  final List<Star> _stars = [];
  final Random _random = Random();

  // For star field motion when user interacts
  Offset _dragOffset = Offset.zero;
  double _dragSpeed = 0;
  bool _isDragging = false;

  // For shooting stars
  final List<ShootingStar> _shootingStars = [];
  int _shootingStarCount = 0;
  final int _maxShootingStars = 5;

  // For constellations
  final List<Constellation> _constellations = [];
  int _activeConstellationIndex = -1;

  @override
  void initState() {
    super.initState();

    // Create animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    // Generate stars
    _generateStars();

    // Generate constellations
    _generateConstellations();

    // Set device to fullscreen immersive mode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  void _generateStars() {
    for (int i = 0; i < 300; i++) {
      _stars.add(
        Star(
          x: _random.nextDouble(),
          y: _random.nextDouble(),
          z: _random.nextDouble() * 3 + 0.1, // Z controls depth/size
          color: _getRandomStarColor(),
          twinkleSpeed: _random.nextDouble() * 2 + 0.5,
        ),
      );
    }
  }

  void _generateConstellations() {
    // Big Dipper
    _constellations.add(
      Constellation(
        name: 'Big Dipper',
        stars: [
          ConstStar(0.2, 0.2),
          ConstStar(0.25, 0.25),
          ConstStar(0.3, 0.27),
          ConstStar(0.35, 0.31),
          ConstStar(0.38, 0.37),
          ConstStar(0.43, 0.32),
          ConstStar(0.48, 0.35),
        ],
        connections: [
          [0, 1],
          [1, 2],
          [2, 3],
          [3, 4],
          [4, 5],
          [5, 6],
        ],
      ),
    );

    // Orion
    _constellations.add(
      Constellation(
        name: 'Orion',
        stars: [
          ConstStar(0.6, 0.15), // Top left shoulder
          ConstStar(0.7, 0.15), // Top right shoulder
          ConstStar(0.65, 0.25), // Belt middle
          ConstStar(0.62, 0.25), // Belt left
          ConstStar(0.68, 0.25), // Belt right
          ConstStar(0.65, 0.35), // Bottom of "skirt"
          ConstStar(0.58, 0.4), // Bottom left leg
          ConstStar(0.72, 0.4), // Bottom right leg
        ],
        connections: [
          [0, 2], // Left shoulder to belt
          [1, 2], // Right shoulder to belt
          [3, 4], // Belt left to right
          [2, 5], // Belt to bottom of skirt
          [5, 6], // Skirt to left leg
          [5, 7], // Skirt to right leg
        ],
      ),
    );

    // Cassiopeia
    _constellations.add(
      Constellation(
        name: 'Cassiopeia',
        stars: [
          ConstStar(0.35, 0.65),
          ConstStar(0.4, 0.7),
          ConstStar(0.45, 0.65),
          ConstStar(0.5, 0.7),
          ConstStar(0.55, 0.65),
        ],
        connections: [
          [0, 1],
          [1, 2],
          [2, 3],
          [3, 4],
        ],
      ),
    );
  }

  Color _getRandomStarColor() {
    // Realistic star colors with blue/white being most common
    final colorChance = _random.nextDouble();

    if (colorChance < 0.7) {
      // White to blue-white stars (most common)
      final blueWhite = _random.nextDouble() * 40;
      return Color.fromARGB(255, 215 + blueWhite.floor(), 235, 255);
    } else if (colorChance < 0.85) {
      // Yellow stars
      return Color.fromARGB(255, 255, 255 - _random.nextInt(40), 220);
    } else if (colorChance < 0.95) {
      // Orange stars
      return Color.fromARGB(255, 255, 200 - _random.nextInt(30), 170);
    } else {
      // Red stars (rare)
      return Color.fromARGB(
        255,
        255,
        150 - _random.nextInt(50),
        150 - _random.nextInt(50),
      );
    }
  }

  void _addShootingStar() {
    if (_shootingStarCount < _maxShootingStars) {
      setState(() {
        _shootingStarCount++;
        _shootingStars.add(
          ShootingStar(
            startX: _random.nextDouble(),
            startY: _random.nextDouble() * 0.3,
            angle: _random.nextDouble() * 0.6 + 0.5,
            length: _random.nextDouble() * 0.15 + 0.05,
            speed: _random.nextDouble() * 4 + 2,
            thickness: _random.nextDouble() * 2 + 1,
          ),
        );
      });

      // Remove shooting star after animation completes
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _shootingStars.removeAt(0);
            _shootingStarCount--;
          });
        }
      });
    }
  }

  void _cycleConstellations() {
    setState(() {
      _activeConstellationIndex++;
      if (_activeConstellationIndex >= _constellations.length) {
        _activeConstellationIndex = -1; // No active constellation
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    // Restore system UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Interactive Star Field',
          style: TextStyle(color: Colors.white, fontSize: 20.sp),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: GestureDetector(
        onPanStart: (details) {
          _isDragging = true;
          _dragOffset = details.localPosition;
        },
        onPanUpdate: (details) {
          if (_isDragging) {
            final newOffset = details.localPosition;
            setState(() {
              // Calculate drag speed and direction
              final dx = newOffset.dx - _dragOffset.dx;
              final dy = newOffset.dy - _dragOffset.dy;
              _dragSpeed = sqrt(dx * dx + dy * dy) * 0.01;

              // Update stars based on drag
              for (var star in _stars) {
                star.x += dx * 0.0005 * star.z;
                star.y += dy * 0.0005 * star.z;

                // Wrap around edges
                if (star.x > 1) star.x -= 1;
                if (star.x < 0) star.x += 1;
                if (star.y > 1) star.y -= 1;
                if (star.y < 0) star.y += 1;
              }

              _dragOffset = newOffset;
            });
          }
        },
        onPanEnd: (_) {
          _isDragging = false;
          // Chance to trigger a shooting star on pan end
          if (_random.nextDouble() < 0.3) {
            _addShootingStar();
          }
        },
        onTap: _cycleConstellations,
        onDoubleTap: _addShootingStar,
        child: Stack(
          children: [
            // Star field
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, _) {
                return CustomPaint(
                  size: Size.infinite,
                  painter: StarFieldPainter(
                    stars: _stars,
                    animationValue: _animationController.value,
                    shootingStars: _shootingStars,
                    activeConstellation:
                        _activeConstellationIndex >= 0
                            ? _constellations[_activeConstellationIndex]
                            : null,
                  ),
                );
              },
            ),

            // UI Overlay
            SafeArea(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Spacer(),
                    // Info panel at bottom
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(15.r),
                        border: Border.all(
                          color: Colors.purpleAccent.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _activeConstellationIndex >= 0
                                ? 'Constellation: ${_constellations[_activeConstellationIndex].name}'
                                : 'Interactive Stargazing',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            '• Drag to move stars',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14.sp,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            '• Double tap for shooting stars',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14.sp,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            '• Tap to cycle constellations',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StarFieldPainter extends CustomPainter {
  final List<Star> stars;
  final double animationValue;
  final List<ShootingStar> shootingStars;
  final Constellation? activeConstellation;

  StarFieldPainter({
    required this.stars,
    required this.animationValue,
    required this.shootingStars,
    this.activeConstellation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final starPaint = Paint()..style = PaintingStyle.fill;

    // Draw stars with twinkling effect
    for (var star in stars) {
      // Calculate twinkling effect
      final twinklePhase = (animationValue * star.twinkleSpeed) % 1.0;
      final twinkleValue =
          sin(twinklePhase * 2 * pi) * 0.3 + 0.7; // Varies between 0.4 and 1.0

      final x = star.x * size.width;
      final y = star.y * size.height;

      // Size based on z-depth (parallax effect)
      final displaySize = star.z;

      starPaint.color = star.color.withOpacity(twinkleValue);
      canvas.drawCircle(Offset(x, y), displaySize, starPaint);
    }

    // Draw shooting stars
    for (var shootingStar in shootingStars) {
      final startX = shootingStar.startX * size.width;
      final startY = shootingStar.startY * size.height;

      final endX =
          startX + cos(shootingStar.angle) * shootingStar.length * size.width;
      final endY =
          startY + sin(shootingStar.angle) * shootingStar.length * size.height;

      // Create a gradient for the trail
      final gradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white,
          Colors.white.withOpacity(0.8),
          Colors.white.withOpacity(0.0),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(
        Rect.fromPoints(Offset(startX, startY), Offset(endX, endY)),
      );

      final trailPaint =
          Paint()
            ..shader = gradient
            ..strokeWidth = shootingStar.thickness
            ..strokeCap = StrokeCap.round
            ..style = PaintingStyle.stroke;

      // Draw the trail
      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), trailPaint);

      // Draw the head of the shooting star
      final headPaint =
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(startX, startY),
        shootingStar.thickness * 1.5,
        headPaint,
      );
    }

    // Draw active constellation if available
    if (activeConstellation != null) {
      // Draw constellation lines
      final linePaint =
          Paint()
            ..color = Colors.white.withOpacity(0.3)
            ..strokeWidth = 1.0
            ..style = PaintingStyle.stroke;

      final pointPaint =
          Paint()
            ..color = Colors.yellow
            ..style = PaintingStyle.fill;

      // Draw connections
      for (var connection in activeConstellation!.connections) {
        final star1 = activeConstellation!.stars[connection[0]];
        final star2 = activeConstellation!.stars[connection[1]];

        canvas.drawLine(
          Offset(star1.x * size.width, star1.y * size.height),
          Offset(star2.x * size.width, star2.y * size.height),
          linePaint,
        );
      }

      // Draw star points (slightly larger than background stars)
      for (var star in activeConstellation!.stars) {
        canvas.drawCircle(
          Offset(star.x * size.width, star.y * size.height),
          3.0,
          pointPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(StarFieldPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.shootingStars.length != shootingStars.length ||
        oldDelegate.activeConstellation != activeConstellation;
  }
}

class Star {
  double x;
  double y;
  final double z; // Z-depth for parallax
  final Color color;
  final double twinkleSpeed;

  Star({
    required this.x,
    required this.y,
    required this.z,
    required this.color,
    required this.twinkleSpeed,
  });
}

class ShootingStar {
  final double startX;
  final double startY;
  final double angle;
  final double length;
  final double speed;
  final double thickness;

  ShootingStar({
    required this.startX,
    required this.startY,
    required this.angle,
    required this.length,
    required this.speed,
    required this.thickness,
  });
}

class ConstStar {
  final double x;
  final double y;

  ConstStar(this.x, this.y);
}

class Constellation {
  final String name;
  final List<ConstStar> stars;
  final List<List<int>> connections; // Pairs of indices into stars array

  Constellation({
    required this.name,
    required this.stars,
    required this.connections,
  });
}
