import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sky_seek/models/planet_model.dart';
import 'dart:math' show pi;

class ComparisonResultScreen extends StatefulWidget {
  final Planet planet1;
  final Planet planet2;
  final Map<String, dynamic>? comparisonData;

  const ComparisonResultScreen({
    super.key,
    required this.planet1,
    required this.planet2,
    this.comparisonData,
  });

  @override
  State<ComparisonResultScreen> createState() => _ComparisonResultScreenState();
}

class _ComparisonResultScreenState extends State<ComparisonResultScreen>
    with TickerProviderStateMixin {
  // Animation controllers
  late final AnimationController _planetController;
  late final AnimationController _tableController;

  // Animations
  late final Animation<double> _planet1Animation;
  late final Animation<double> _planet2Animation;
  late final Animation<double> _vsAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize planet animation controller
    _planetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Initialize table animation controller
    _tableController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Planet 1 animation - enters from left
    _planet1Animation = Tween<double>(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _planetController,
        curve: Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    // Planet 2 animation - enters from right
    _planet2Animation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _planetController,
        curve: Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    // VS text animation - fades in and scales up
    _vsAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _planetController,
        curve: Interval(0.3, 0.7, curve: Curves.easeInOut),
      ),
    );

    // Start animations after a short delay
    Future.delayed(Duration(milliseconds: 200), () {
      _planetController.forward();
      Future.delayed(Duration(milliseconds: 600), () {
        _tableController.forward();
      });
    });
  }

  @override
  void dispose() {
    _planetController.dispose();
    _tableController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Planet Comparison',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontFamily: 'SpaceGrotesk',
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          // Background
          SizedBox.expand(
            child: Stack(
              children: [
                // Stars background
                Image.asset(
                  'assets/images/infobg.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                // Gradient overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.black.withOpacity(0.8),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          SafeArea(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: _buildComparisonSection(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build comparison table
  Widget _buildComparisonSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white24, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Planets images and names header
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                // Planet 1 header - Animated from left
                Expanded(
                  child: AnimatedBuilder(
                    animation: _planetController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(_planet1Animation.value * 100.w, 0),
                        child: Opacity(
                          opacity: 1 - _planet1Animation.value.abs(),
                          child: child,
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        _buildPlanetImage(widget.planet1, isFirstPlanet: true),
                        SizedBox(height: 8.h),
                        Text(
                          widget.planet1.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontFamily: 'SpaceGrotesk',
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          widget.planet1.type,
                          style: TextStyle(
                            color: Colors.tealAccent,
                            fontSize: 12.sp,
                            fontFamily: 'SpaceGrotesk',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

                // VS divider - Animated fade in
                AnimatedBuilder(
                  animation: _planetController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _vsAnimation.value,
                      child: Transform.scale(
                        scale: _vsAnimation.value,
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    width: 1,
                    height: 100.h,
                    color: Colors.white24,
                    margin: EdgeInsets.symmetric(horizontal: 16.w),
                  ),
                ),

                // Planet 2 header - Animated from right
                Expanded(
                  child: AnimatedBuilder(
                    animation: _planetController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(_planet2Animation.value * 100.w, 0),
                        child: Opacity(
                          opacity: 1 - _planet2Animation.value.abs(),
                          child: child,
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        _buildPlanetImage(widget.planet2, isFirstPlanet: false),
                        SizedBox(height: 8.h),
                        Text(
                          widget.planet2.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontFamily: 'SpaceGrotesk',
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          widget.planet2.type,
                          style: TextStyle(
                            color: Colors.tealAccent,
                            fontSize: 12.sp,
                            fontFamily: 'SpaceGrotesk',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Divider(color: Colors.white24),

          // Comparison table
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildComparisonTitle('Physical Characteristics'),
                _buildAnimatedComparisonRow(
                  'Position',
                  widget.planet1.position,
                  widget.planet2.position,
                  index: 0,
                ),
                _buildAnimatedComparisonRow(
                  'Diameter',
                  widget.planet1.diameter,
                  widget.planet2.diameter,
                  index: 1,
                ),
                _buildAnimatedComparisonRow(
                  'Mass',
                  widget.planet1.mass,
                  widget.planet2.mass,
                  index: 2,
                ),
                _buildAnimatedComparisonRow(
                  'Gravity',
                  widget.planet1.gravity,
                  widget.planet2.gravity,
                  index: 3,
                ),

                SizedBox(height: 16.h),
                _buildComparisonTitle('Orbital Properties'),
                _buildAnimatedComparisonRow(
                  'Distance from Sun',
                  widget.planet1.distanceFromSun,
                  widget.planet2.distanceFromSun,
                  index: 4,
                ),
                _buildAnimatedComparisonRow(
                  'Orbital Period',
                  widget.planet1.orbitalPeriod,
                  widget.planet2.orbitalPeriod,
                  index: 5,
                ),
                _buildAnimatedComparisonRow(
                  'Rotation Period',
                  widget.planet1.rotationPeriod,
                  widget.planet2.rotationPeriod,
                  index: 6,
                ),
                _buildAnimatedComparisonRow(
                  'Moons',
                  widget.planet1.moons,
                  widget.planet2.moons,
                  index: 7,
                ),

                SizedBox(height: 16.h),
                _buildComparisonTitle('Atmosphere & Environment'),
                _buildAnimatedComparisonRow(
                  'Atmosphere',
                  widget.planet1.atmosphereComposition,
                  widget.planet2.atmosphereComposition,
                  index: 8,
                ),
                _buildAnimatedComparisonRow(
                  'Min Temperature',
                  widget.planet1.temperatureMin,
                  widget.planet2.temperatureMin,
                  index: 9,
                ),
                _buildAnimatedComparisonRow(
                  'Max Temperature',
                  widget.planet1.temperatureMax,
                  widget.planet2.temperatureMax,
                  index: 10,
                ),
                _buildAnimatedComparisonRow(
                  'Has Rings',
                  widget.planet1.rings ? 'Yes' : 'No',
                  widget.planet2.rings ? 'Yes' : 'No',
                  index: 11,
                ),
                _buildAnimatedComparisonRow(
                  'Supports Life',
                  widget.planet1.supportsLife ? 'Yes' : 'No',
                  widget.planet2.supportsLife ? 'Yes' : 'No',
                  index: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Build planet image with rotation animation
  Widget _buildPlanetImage(Planet planet, {required bool isFirstPlanet}) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 2 * pi),
      duration: Duration(seconds: isFirstPlanet ? 20 : 15),
      curve: Curves.linear,
      builder: (context, value, child) {
        return Transform.rotate(
          angle: isFirstPlanet ? value : -value,
          child: Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.tealAccent.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: ClipOval(child: child),
          ),
        );
      },
      child: ClipOval(
        child:
            planet.image.isNotEmpty
                ? Image.network(
                  planet.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade900,
                      child: Icon(
                        Icons.public,
                        color: Colors.white70,
                        size: 30.sp,
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.tealAccent,
                        value:
                            loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                      ),
                    );
                  },
                )
                : Container(
                  color: Colors.grey.shade900,
                  child: Icon(Icons.public, color: Colors.white70, size: 30.sp),
                ),
      ),
    );
  }

  // Build comparison section title
  Widget _buildComparisonTitle(String title) {
    return AnimatedBuilder(
      animation: _tableController,
      builder: (context, child) {
        return Opacity(opacity: _tableController.value, child: child);
      },
      child: _buildTitleContent(title),
    );
  }

  Widget _buildTitleContent(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.tealAccent,
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Build animated comparison row with staggered animation
  Widget _buildAnimatedComparisonRow(
    String label,
    String value1,
    String value2, {
    required int index,
  }) {
    return AnimatedBuilder(
      animation: _tableController,
      builder: (context, child) {
        // Stagger animations based on index
        final delay = index * 0.1;
        final start = delay;
        final end = start + 0.2;

        // Calculate current animation value for this row
        final animValue = _tableController.value;
        double opacity = 0.0;
        double slideValue = 20.0;

        if (animValue >= start) {
          opacity = (animValue - start) / (end - start);
          if (opacity > 1.0) opacity = 1.0;
          slideValue = 20.0 * (1.0 - opacity);
        }

        return Opacity(
          opacity: opacity,
          child: Transform.translate(
            offset: Offset(0, slideValue),
            child: child,
          ),
        );
      },
      child: _buildComparisonRow(label, value1, value2),
    );
  }

  // Build comparison table row content
  Widget _buildComparisonRow(String label, String value1, String value2) {
    // Determine if values are different
    final bool isDifferent = value1 != value2;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
          // Label
          SizedBox(
            width: 100.w,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12.sp,
                fontFamily: 'SpaceGrotesk',
              ),
            ),
          ),

          // Value 1
          Expanded(
            child: Text(
              value1,
              style: TextStyle(
                color: isDifferent ? Colors.white : Colors.white70,
                fontSize: 12.sp,
                fontFamily: 'Poppins',
                fontWeight: isDifferent ? FontWeight.bold : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Value 2
          Expanded(
            child: Text(
              value2,
              style: TextStyle(
                color: isDifferent ? Colors.white : Colors.white70,
                fontSize: 12.sp,
                fontFamily: 'Poppins',
                fontWeight: isDifferent ? FontWeight.bold : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
