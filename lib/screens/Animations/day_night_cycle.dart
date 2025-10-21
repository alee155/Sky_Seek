import 'dart:math';
import 'package:flutter/material.dart';

class EarthOrbitScreen extends StatefulWidget {
  const EarthOrbitScreen({super.key});

  @override
  State<EarthOrbitScreen> createState() => _EarthOrbitScreenState();
}

class _EarthOrbitScreenState extends State<EarthOrbitScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(); // Continuous orbit
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildOrbitingBody({
    required double radius,
    required double size,
    required Color color,
    required double angleOffset,
    String? asset,
  }) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final angle = 2 * pi * _controller.value + angleOffset;
        final x = radius * cos(angle);
        final y = radius * sin(angle);
        return Transform.translate(offset: Offset(x, y), child: child);
      },
      child:
          asset != null
              ? Image.asset(asset, width: size, height: size)
              : Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.6),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 🌍 Earth in center
            Container(
              width: 150,
              height: 150,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent,
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/earth.png', // <- your Earth image
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // ☀️ Sun orbiting
            _buildOrbitingBody(
              radius: 120,
              size: 40,
              color: Colors.orange,
              angleOffset: 0,
              asset: 'assets/images/sun.png', // optional
            ),

            // 🌙 Moon orbiting
            _buildOrbitingBody(
              radius: 80,
              size: 30,
              color: Colors.grey.shade300,
              angleOffset: pi,
              asset: 'assets/images/moon.png', // optional
            ),
          ],
        ),
      ),
    );
  }
}
