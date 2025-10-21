import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RotatingPlanet extends StatefulWidget {
  final String imageUrl;
  final String id;
  final double size;
  final Duration rotationDuration;
  final Color glowColor;
  final double glowIntensity;

  const RotatingPlanet({
    Key? key,
    required this.imageUrl,
    required this.id,
    this.size = 150,
    this.rotationDuration = const Duration(seconds: 20),
    this.glowColor = Colors.tealAccent,
    this.glowIntensity = 0.2,
  }) : super(key: key);

  @override
  State<RotatingPlanet> createState() => _RotatingPlanetState();
}

class _RotatingPlanetState extends State<RotatingPlanet>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: widget.rotationDuration,
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
        return Transform.rotate(
          angle: _controller.value * 2 * pi,
          child: Container(
            width: widget.size.w,
            height: widget.size.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: widget.glowColor.withOpacity(widget.glowIntensity),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: child,
          ),
        );
      },
      child: Hero(
        tag: 'planet_${widget.id}',
        child: ClipOval(
          child: Image.network(
            widget.imageUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                  color: widget.glowColor,
                  strokeWidth: 2,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.black45,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.public,
                    color: Colors.white70,
                    size: (widget.size / 3.5).sp,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
