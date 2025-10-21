import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EarthMoonAnimation extends StatefulWidget {
  const EarthMoonAnimation({super.key});

  @override
  State<EarthMoonAnimation> createState() => _EarthMoonAnimationState();
}

class _EarthMoonAnimationState extends State<EarthMoonAnimation>
    with TickerProviderStateMixin {
  late AnimationController _earthRotationController;
  late AnimationController _moonOrbitController;
  late AnimationController _starTwinkleController;
  
  // Stars data
  final List<Map<String, dynamic>> _stars = [];
  final Random _random = Random();
  
  @override
  void initState() {
    super.initState();
    
    // Earth rotation - completes in 24 seconds
    _earthRotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 24),
    )..repeat();
    
    // Moon orbit - completes in 60 seconds
    _moonOrbitController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat();
    
    // Star twinkling
    _starTwinkleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    
    // Generate random stars
    _generateStars();
  }
  
  void _generateStars() {
    for (int i = 0; i < 100; i++) {
      _stars.add({
        'x': _random.nextDouble(),
        'y': _random.nextDouble(),
        'size': _random.nextDouble() * 2 + 0.5,
        'opacity': _random.nextDouble() * 0.7 + 0.3,
      });
    }
  }

  @override
  void dispose() {
    _earthRotationController.dispose();
    _moonOrbitController.dispose();
    _starTwinkleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Earth size and position
    final earthSize = screenWidth * 0.4;
    final centerX = screenWidth / 2;
    final centerY = screenWidth * 0.7;
    
    // Moon size and orbit
    final moonSize = earthSize * 0.27;  // Moon is about 27% of Earth's size
    final orbitRadius = screenWidth * 0.3;  // Orbit radius
    
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Earth & Moon',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Stars in background
          AnimatedBuilder(
            animation: _starTwinkleController,
            builder: (context, _) {
              return CustomPaint(
                size: Size.infinite,
                painter: StarFieldPainter(
                  stars: _stars,
                  twinkleValue: _starTwinkleController.value,
                ),
              );
            },
          ),
          
          // Earth
          Positioned(
            left: centerX - earthSize / 2,
            top: centerY - earthSize / 2,
            child: AnimatedBuilder(
              animation: _earthRotationController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _earthRotationController.value * 2 * pi,
                  child: Container(
                    width: earthSize,
                    height: earthSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                      image: const DecorationImage(
                        image: AssetImage('assets/images/earth.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Moon orbit path (subtle circle)
          Positioned(
            left: centerX - orbitRadius,
            top: centerY - orbitRadius,
            child: Container(
              width: orbitRadius * 2,
              height: orbitRadius * 2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
          ),
          
          // Moon
          AnimatedBuilder(
            animation: _moonOrbitController,
            builder: (context, child) {
              // Calculate moon position on its orbit
              final angle = _moonOrbitController.value * 2 * pi;
              final moonX = centerX + cos(angle) * orbitRadius - moonSize / 2;
              final moonY = centerY + sin(angle) * orbitRadius - moonSize / 2;
              
              return Positioned(
                left: moonX,
                top: moonY,
                child: Container(
                  width: moonSize,
                  height: moonSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.2),
                        blurRadius: 15,
                        spreadRadius: 1,
                      ),
                    ],
                    image: const DecorationImage(
                      image: AssetImage('assets/images/moon.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
          
          // Information panel
          Positioned(
            bottom: 30.h,
            left: 20.w,
            right: 20.w,
            child: Container(
              padding: EdgeInsets.all(15.w),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(15.r),
                border: Border.all(
                  color: Colors.tealAccent.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Earth & Moon System',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    '• Earth rotates on its axis once every 24 hours',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    '• Moon orbits Earth once every 27.3 days',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    '• Moon is about 27% the size of Earth',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StarFieldPainter extends CustomPainter {
  final List<Map<String, dynamic>> stars;
  final double twinkleValue;
  
  StarFieldPainter({required this.stars, required this.twinkleValue});
  
  @override
  void paint(Canvas canvas, Size size) {
    for (var star in stars) {
      final x = star['x'] * size.width;
      final y = star['y'] * size.height;
      final starSize = star['size'] as double;
      final baseOpacity = star['opacity'] as double;
      
      // Calculate twinkling effect
      final opacity = baseOpacity * (0.5 + twinkleValue * 0.5);
      
      final paint = Paint()
        ..color = Colors.white.withOpacity(opacity)
        ..style = PaintingStyle.fill;
        
      canvas.drawCircle(Offset(x, y), starSize, paint);
    }
  }
  
  @override
  bool shouldRepaint(StarFieldPainter oldDelegate) {
    return oldDelegate.twinkleValue != twinkleValue;
  }
}
