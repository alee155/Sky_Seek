import 'dart:math';
import 'package:flutter/material.dart';

class CosmicParticleBackground extends StatefulWidget {
  final int particleCount;
  final List<Color> colors;
  final double opacity;

  const CosmicParticleBackground({
    super.key,
    this.particleCount = 50,
    this.colors = const [
      Colors.tealAccent,
      Colors.purpleAccent,
      Colors.blueAccent,
      Colors.pinkAccent,
    ],
    this.opacity = 1.0,
  });

  @override
  State<CosmicParticleBackground> createState() =>
      _CosmicParticleBackgroundState();
}

class _CosmicParticleBackgroundState extends State<CosmicParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<CosmicParticle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _generateParticles();
  }

  void _generateParticles() {
    for (int i = 0; i < widget.particleCount; i++) {
      _particles.add(
        CosmicParticle(
          x: _random.nextDouble(),
          y: _random.nextDouble(),
          size: _random.nextDouble() * 8 + 2, // Size between 2 and 10
          opacity:
              _random.nextDouble() * 0.4 + 0.1, // Opacity between 0.1 and 0.5
          speed: _random.nextDouble() * 0.02 + 0.005, // Speed of movement
          color: widget.colors[_random.nextInt(widget.colors.length)],
          blurRadius:
              _random.nextDouble() * 15 + 5, // Blur radius between 5 and 20
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
            painter: CosmicParticlePainter(
              particles: _particles,
              animation: _controller.value,
              opacity: widget.opacity,
            ),
            isComplex: true,
          );
        },
      ),
    );
  }
}

class CosmicParticlePainter extends CustomPainter {
  final List<CosmicParticle> particles;
  final double animation;
  final double opacity;

  CosmicParticlePainter({
    required this.particles,
    required this.animation,
    this.opacity = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      // Calculate particle position with motion
      final baseX = particle.x;
      final baseY = particle.y;

      // Create a subtle flowing motion
      final offsetX = sin((animation + baseX) * 2 * pi) * 0.1;
      final offsetY = cos((animation + baseY) * 2 * pi) * 0.1;

      final x =
          ((baseX + offsetX + particle.speed * animation) % 1.0) * size.width;
      final y =
          ((baseY + offsetY + particle.speed * animation * 0.5) % 1.0) *
          size.height;

      // Apply size pulsation effect
      final sizeMultiplier = 0.8 + sin(animation * pi * 2 * 0.3) * 0.2;
      final currentSize = particle.size * sizeMultiplier;

      // Create a glowing effect
      final paint =
          Paint()
            ..color = particle.color.withOpacity(particle.opacity * opacity)
            ..maskFilter = MaskFilter.blur(
              BlurStyle.normal,
              particle.blurRadius,
            );

      canvas.drawCircle(Offset(x, y), currentSize, paint);
    }
  }

  @override
  bool shouldRepaint(CosmicParticlePainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}

class CosmicParticle {
  final double x;
  final double y;
  final double size;
  final double opacity;
  final double speed;
  final Color color;
  final double blurRadius;

  CosmicParticle({
    required this.x,
    required this.y,
    required this.size,
    required this.opacity,
    required this.speed,
    required this.color,
    required this.blurRadius,
  });
}
