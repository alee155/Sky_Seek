import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SolarSystemAnimation extends StatefulWidget {
  const SolarSystemAnimation({super.key});

  @override
  State<SolarSystemAnimation> createState() => _SolarSystemAnimationState();
}

class _SolarSystemAnimationState extends State<SolarSystemAnimation>
    with TickerProviderStateMixin {
  late AnimationController _sunRotationController;
  late List<AnimationController> _planetOrbitControllers;
  final List<Map<String, dynamic>> _planets = [];

  @override
  void initState() {
    super.initState();

    _sunRotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat();

    _planets.addAll([
      {
        'name': 'Mercury',
        'color': Colors.grey[300]!,
        'size': 10.0,
        'orbitRadius': 50.0,
        'orbitDuration': const Duration(seconds: 20),
        'image': 'assets/images/MURCRY.png',
      },
      {
        'name': 'Venus',
        'color': Colors.orangeAccent,
        'size': 15.0,
        'orbitRadius': 80.0,
        'orbitDuration': const Duration(seconds: 30),
        'image': 'assets/images/VENUS.png',
      },
      {
        'name': 'Earth',
        'color': Colors.blue,
        'size': 16.0,
        'orbitRadius': 110.0,
        'orbitDuration': const Duration(seconds: 20),
        'image': 'assets/images/earth.png',
      },
      {
        'name': 'Mars',
        'color': Colors.red[700]!,
        'size': 14.0,
        'orbitRadius': 140.0,
        'orbitDuration': const Duration(seconds: 25),
        'image': 'assets/images/MARC.png',
      },
      {
        'name': 'Jupiter',
        'color': Colors.amber[800]!,
        'size': 30.0,
        'orbitRadius': 190.0,
        'orbitDuration': const Duration(seconds: 40),
        'image': 'assets/images/JUPITAR.png',
      },
      {
        'name': 'Saturn',
        'color': Colors.amber[600]!,
        'size': 28.0,
        'orbitRadius': 240.0,
        'orbitDuration': const Duration(seconds: 50),
        'image': 'assets/images/SATRUN.png',
      },
    ]);

    _planetOrbitControllers =
        _planets.map((planet) {
          return AnimationController(
            vsync: this,
            duration: planet['orbitDuration'],
          )..repeat();
        }).toList();
  }

  @override
  void dispose() {
    _sunRotationController.dispose();
    for (var controller in _planetOrbitControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final centerX = screenSize.width / 2;
    final centerY = screenSize.height / 2 - 50.h;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Solar System',
          style: TextStyle(color: Colors.white, fontSize: 20.sp),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: Stack(
        children: [
          CustomPaint(size: Size.infinite, painter: StarsPainter()),

          Positioned(
            left: centerX - 35.w,
            top: centerY - 35.w,
            child: AnimatedBuilder(
              animation: _sunRotationController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _sunRotationController.value * 2 * pi,
                  child: Container(
                    width: 70.w,
                    height: 70.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const RadialGradient(
                        colors: [Colors.yellow, Colors.orange, Colors.red],
                        stops: [0.2, 0.7, 1.0],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.yellow.withOpacity(0.7),
                          blurRadius: 30,
                          spreadRadius: 15,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          for (var i = 0; i < _planets.length; i++)
            ..._buildPlanetWithOrbit(
              centerX,
              centerY,
              _planets[i],
              _planetOrbitControllers[i],
            ),

          Positioned(
            top: 0.h,
            left: 5.w,
            right: 5.w,
            child: Container(
              padding: EdgeInsets.all(15.w),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(15.r),
                border: Border.all(
                  color: Colors.amberAccent.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Solar System',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    '• The Sun contains 99.86% of the mass in the solar system',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 10.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '• Jupiter is the largest planet, over 1000 Earths could fit inside it',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 10.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '• It takes 8 minutes for light from the Sun to reach Earth',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),

          for (var i = 0; i < _planets.length; i++)
            AnimatedBuilder(
              animation: _planetOrbitControllers[i],
              builder: (context, child) {
                final planet = _planets[i];
                final angle = _planetOrbitControllers[i].value * 2 * pi;
                final orbitRadius = planet['orbitRadius'] as double;

                final planetX = centerX + cos(angle) * orbitRadius;
                final planetY = centerY + sin(angle) * orbitRadius;

                return Positioned(
                  left: planetX - 20.w,
                  top: planetY + planet['size'] + 5.h,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: planet['color'].withOpacity(0.5),
                        width: 0.5,
                      ),
                    ),
                    child: Text(
                      planet['name'],
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 10.sp,
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  List<Widget> _buildPlanetWithOrbit(
    double centerX,
    double centerY,
    Map<String, dynamic> planet,
    AnimationController controller,
  ) {
    final orbitRadius = planet['orbitRadius'] as double;
    final planetSize = planet['size'] as double;
    final planetColor = planet['color'] as Color;
    final planetImage = planet['image'] as String;

    return [
      Positioned(
        left: centerX - orbitRadius,
        top: centerY - orbitRadius,
        child: Container(
          width: orbitRadius * 2,
          height: orbitRadius * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
          ),
        ),
      ),

      AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          final angle = controller.value * 2 * pi;
          final planetX = centerX + cos(angle) * orbitRadius - planetSize / 2;
          final planetY = centerY + sin(angle) * orbitRadius - planetSize / 2;

          return Positioned(
            left: planetX,
            top: planetY,
            child: Container(
              width: planetSize,
              height: planetSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(planetImage),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: planetColor.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ];
  }
}

class StarsPainter extends CustomPainter {
  final Random _random = Random();

  @override
  void paint(Canvas canvas, Size size) {
    final starPaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;

    for (int i = 0; i < 100; i++) {
      final x = _random.nextDouble() * size.width;
      final y = _random.nextDouble() * size.height;
      final radius = _random.nextDouble() * 1.5 + 0.5;
      final opacity = _random.nextDouble() * 0.7 + 0.3;

      starPaint.color = Colors.white.withOpacity(opacity);
      canvas.drawCircle(Offset(x, y), radius, starPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
