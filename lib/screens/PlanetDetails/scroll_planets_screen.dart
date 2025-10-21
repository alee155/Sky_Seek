import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sky_seek/controller/planet_controller.dart';
import 'package:sky_seek/services/auth_service.dart';
import 'package:sky_seek/widgets/animated_info_tile.dart';
import 'package:sky_seek/widgets/earth_loader.dart';
import 'package:sky_seek/widgets/rotating_planet.dart';
import 'package:sky_seek/widgets/star_background.dart';

class ScrollPlanetsScreen extends StatefulWidget {
  const ScrollPlanetsScreen({super.key});

  @override
  State<ScrollPlanetsScreen> createState() => _ScrollPlanetsScreenState();
}

class _ScrollPlanetsScreenState extends State<ScrollPlanetsScreen>
    with TickerProviderStateMixin {
  final PlanetController controller = Get.put(PlanetController());

  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _detailsController;
  late AnimationController _headerController;

  // Animations
  late Animation<double> _headerFadeAnimation;
  late Animation<double> _headerSlideAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize controllers
    _fadeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    _detailsController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
    );

    _headerController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );

    // Header animations
    _headerFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _headerController,
        curve: Interval(0.0, 0.8, curve: Curves.easeOut),
      ),
    );

    _headerSlideAnimation = Tween<double>(begin: -30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _headerController,
        curve: Interval(0.0, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    // Start animations
    _fadeController.forward();
    _headerController.forward();
    _detailsController.forward();

    // Add listener to planet controller
    ever(controller.currentPlanetIndex, (_) {
      _resetAndPlayAnimations();
    });
  }

  void _resetAndPlayAnimations() {
    _detailsController.reset();
    Future.delayed(Duration(milliseconds: 100), () {
      _detailsController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _detailsController.dispose();
    _headerController.dispose();
    super.dispose();
  }

  // Helper method to get appropriate glow color based on planet type
  Color _getPlanetGlowColor(dynamic planet) {
    if (planet.type.toLowerCase().contains('gas')) {
      return Colors.blueAccent;
    } else if (planet.type.toLowerCase().contains('terrestrial')) {
      return Colors.tealAccent;
    } else if (planet.type.toLowerCase().contains('ice')) {
      return Colors.cyanAccent;
    } else {
      return Colors.purpleAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_sharp),
          onPressed: () => Get.back(),
          color: Colors.white,
        ),
      ),
      body: Stack(
        children: [
          // Background with stars
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/images/infobg.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                // Animated stars overlay
                Opacity(opacity: 0.6, child: StarBackground(starCount: 300)),
                // Gradient overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.3),
                        Colors.black.withOpacity(0.6),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Space themed accent light
          Positioned(
            top: -100,
            left: 0,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.15),
                    blurRadius: 100,
                    spreadRadius: 100,
                  ),
                ],
              ),
            ),
          ),

          // Space themed accent light (right side)
          Positioned(
            bottom: -50,
            right: 0,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.lightBlueAccent.withOpacity(0.1),
                    blurRadius: 80,
                    spreadRadius: 40,
                  ),
                ],
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                if (controller.isLoading.value) {
                  return Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        EarthLoader(size: 60),
                        10.h.verticalSpace,
                        Text(
                          "Loading...",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (controller.planets.isEmpty) {
                  return const Expanded(
                    child: Center(
                      child: Text(
                        "No planets found",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                }

                final planet =
                    controller.planets[controller.currentPlanetIndex.value];

                return Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        100.h.verticalSpace,
                        // Animated header
                        AnimatedBuilder(
                          animation: _headerController,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(0, _headerSlideAnimation.value),
                              child: Opacity(
                                opacity: _headerFadeAnimation.value,
                                child: child,
                              ),
                            );
                          },
                          child: _buildPlanetHeader(planet),
                        ),

                        // Planet image carousel
                        _buildPlanetImage(planet),

                        // Planet information with animated sections
                        _buildAnimatedSectionTitle("Physical", 0),
                        AnimatedInfoTile(
                          icon: Icons.straighten,
                          title: "Planet",
                          value: planet.name,
                          index: 0,
                          animationController: _detailsController,
                        ),
                        AnimatedInfoTile(
                          icon: Icons.straighten,
                          title: "Diameter",
                          value: planet.diameter,
                          index: 1,
                          animationController: _detailsController,
                        ),
                        AnimatedInfoTile(
                          icon: Icons.public,
                          title: "Mass",
                          value: planet.mass,
                          index: 2,
                          animationController: _detailsController,
                        ),
                        AnimatedInfoTile(
                          icon: Icons.compress,
                          title: "Gravity",
                          value: planet.gravity,
                          index: 3,
                          animationController: _detailsController,
                        ),
                        AnimatedInfoTile(
                          icon: Icons.loop,
                          title: "Rotation Period",
                          value: planet.rotationPeriod,
                          index: 4,
                          animationController: _detailsController,
                        ),
                        AnimatedInfoTile(
                          icon: Icons.access_time_filled,
                          title: "Solar Day",
                          value: planet.solarDay,
                          index: 5,
                          animationController: _detailsController,
                        ),
                        AnimatedInfoTile(
                          icon: Icons.timeline,
                          title: "Orbital Period",
                          value: planet.orbitalPeriod,
                          index: 6,
                          animationController: _detailsController,
                        ),
                        AnimatedInfoTile(
                          icon: Icons.circle_outlined,
                          title: "Symbol",
                          value: planet.symbol,
                          index: 7,
                          animationController: _detailsController,
                        ),
                        AnimatedInfoTile(
                          icon: Icons.landscape,
                          title: "Surface",
                          value: planet.surface,
                          index: 8,
                          animationController: _detailsController,
                        ),

                        _buildAnimatedSectionTitle("Orbital Properties", 9),
                        AnimatedInfoTile(
                          icon: Icons.linear_scale,
                          title: "Distance from Sun",
                          value: planet.distanceFromSun,
                          index: 10,
                          animationController: _detailsController,
                        ),
                        AnimatedInfoTile(
                          icon: Icons.blur_circular,
                          title: "Eccentricity",
                          value: planet.eccentricity,
                          index: 11,
                          animationController: _detailsController,
                        ),
                        AnimatedInfoTile(
                          icon: Icons.nights_stay,
                          title: "Moons",
                          value: planet.moons,
                          index: 12,
                          animationController: _detailsController,
                        ),
                        AnimatedInfoTile(
                          icon: Icons.track_changes,
                          title: "Position",
                          value: planet.position,
                          index: 13,
                          animationController: _detailsController,
                        ),

                        _buildAnimatedSectionTitle("Atmosphere", 14),
                        AnimatedInfoTile(
                          icon: Icons.cloud_outlined,
                          title: "Composition",
                          value: planet.atmosphereComposition,
                          index: 15,
                          animationController: _detailsController,
                        ),
                        AnimatedInfoTile(
                          icon: Icons.speed,
                          title: "Pressure",
                          value: planet.atmospherePressure,
                          index: 16,
                          animationController: _detailsController,
                        ),
                        AnimatedInfoTile(
                          icon: Icons.ac_unit,
                          title: "Temperature Min",
                          value: planet.temperatureMin,
                          index: 17,
                          animationController: _detailsController,
                        ),
                        AnimatedInfoTile(
                          icon: Icons.local_fire_department,
                          title: "Temperature Max",
                          value: planet.temperatureMax,
                          index: 18,
                          animationController: _detailsController,
                        ),

                        _buildAnimatedSectionTitle("Other Features", 19),
                        AnimatedInfoTile(
                          icon: Icons.album,
                          title: "Rings",
                          value: planet.rings ? "Yes" : "No",
                          index: 20,
                          animationController: _detailsController,
                          iconColor:
                              planet.rings ? Colors.amberAccent : Colors.grey,
                        ),
                        AnimatedInfoTile(
                          icon: Icons.shield,
                          title: "Magnetic Field",
                          value: planet.magneticField ? "Yes" : "No",
                          index: 21,
                          animationController: _detailsController,
                          iconColor:
                              planet.magneticField
                                  ? Colors.blueAccent
                                  : Colors.grey,
                        ),
                        AnimatedInfoTile(
                          icon: Icons.favorite,
                          title: "Supports Life",
                          value: planet.supportsLife ? "Yes" : "No",
                          index: 22,
                          animationController: _detailsController,
                          iconColor:
                              planet.supportsLife
                                  ? Colors.greenAccent
                                  : Colors.grey,
                        ),

                        _buildAnimatedSectionTitle("Trivia", 23),
                        _buildAnimatedMultiLineTile(
                          Icons.lightbulb_outline,
                          planet.trivia,
                        ),
                        100.h.verticalSpace,
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
      bottomSheet: Obx(() {
        final currentPlanet =
            controller.planets.isNotEmpty
                ? controller.planets[controller.currentPlanetIndex.value]
                : null;

        if (currentPlanet == null) {
          return SizedBox.shrink();
        }

        // We don't need to get planet order here

        return Container(
          height: 90.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.vertical(top: Radius.circular(10.r)),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 1.0, end: 1.07),
                    duration: Duration(milliseconds: 700),
                    curve: Curves.easeInOut,
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale:
                            controller.currentPlanetIndex.value > 0
                                ? value
                                : 1.0,
                        child: Container(
                          height: 38.h,
                          width: 38.w,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color:
                                  controller.currentPlanetIndex.value > 0
                                      ? Colors.tealAccent.withOpacity(0.7)
                                      : Colors.white24,
                              width:
                                  controller.currentPlanetIndex.value > 0
                                      ? 1.5
                                      : 1.0,
                            ),
                            boxShadow:
                                controller.currentPlanetIndex.value > 0
                                    ? [
                                      BoxShadow(
                                        color: Colors.tealAccent.withOpacity(
                                          0.2,
                                        ),
                                        blurRadius: 5,
                                      ),
                                    ]
                                    : [],
                          ),
                          child: Center(
                            child: IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                                color:
                                    controller.currentPlanetIndex.value > 0
                                        ? Colors.tealAccent
                                        : Colors.white30,
                              ),
                              onPressed:
                                  controller.currentPlanetIndex.value > 0
                                      ? () => controller.previousPlanet()
                                      : null,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  // Favorite button with loading indicator
                  GestureDetector(
                    onTap: () async {
                      // Get the token from shared preferences
                      final token = await AuthService.getToken();
                      if (token != null && token.isNotEmpty) {
                        // Call the add to favorite method
                        await controller.addToFavorite(token);
                      } else {
                        Get.snackbar(
                          'Error',
                          'Please log in to add planets to favorites',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red.withOpacity(0.7),
                          colorText: Colors.white,
                        );
                      }
                    },
                    child: TweenAnimationBuilder(
                      tween: Tween<double>(begin: 1.0, end: 1.05),
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: Container(
                            height: 58.h,
                            width: 220.w,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/fav.png'),
                                fit: BoxFit.cover,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.purpleAccent.withOpacity(0.2),
                                  blurRadius: 15,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Obx(
                                () =>
                                    controller.isFavoriting.value
                                        ? SizedBox(
                                          width: 20.w,
                                          height: 20.h,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                        : ShaderMask(
                                          shaderCallback: (Rect bounds) {
                                            return LinearGradient(
                                              colors: [
                                                Colors.white,
                                                Colors.tealAccent,
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ).createShader(bounds);
                                          },
                                          child: Text(
                                            "Favorite",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 1.0, end: 1.07),
                    duration: Duration(milliseconds: 700),
                    curve: Curves.easeInOut,
                    builder: (context, value, child) {
                      bool hasMorePlanets =
                          controller.currentPlanetIndex.value <
                          controller.planets.length - 1;
                      return Transform.scale(
                        scale: hasMorePlanets ? value : 1.0,
                        child: Container(
                          height: 38.h,
                          width: 38.w,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color:
                                  hasMorePlanets
                                      ? Colors.tealAccent.withOpacity(0.7)
                                      : Colors.white24,
                              width: hasMorePlanets ? 1.5 : 1.0,
                            ),
                            boxShadow:
                                hasMorePlanets
                                    ? [
                                      BoxShadow(
                                        color: Colors.tealAccent.withOpacity(
                                          0.2,
                                        ),
                                        blurRadius: 5,
                                      ),
                                    ]
                                    : [],
                          ),
                          child: Center(
                            child: IconButton(
                              icon: Icon(
                                Icons.arrow_forward,
                                color:
                                    hasMorePlanets
                                        ? Colors.tealAccent
                                        : Colors.white30,
                              ),
                              onPressed:
                                  hasMorePlanets
                                      ? () => controller.nextPlanet()
                                      : null,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  // Planet avatar display with enhanced solar system position information
  Widget _buildPlanetImage(planet) {
    // Get the numeric order of the planet for the rotation speed
    final positionRegex = RegExp(r'(\d+)');
    final match = positionRegex.firstMatch(planet.position);
    int planetOrder = 0;
    if (match != null) {
      planetOrder = int.tryParse(match.group(0) ?? '0') ?? 0;
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        children: [
          // First row with avatar and position text
          Row(
            children: [
              // Animated planet with rotation
              FadeTransition(
                opacity: _fadeController,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset(-0.2, 0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: _fadeController,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
                  child: RotatingPlanet(
                    imageUrl: planet.image,
                    id: planet.id,
                    size: 150,
                    rotationDuration: Duration(
                      seconds: 20 + (planetOrder * 3),
                    ), // Varies rotation speed based on planet's position
                    glowColor: _getPlanetGlowColor(planet),
                    glowIntensity: 0.2,
                  ),
                ),
              ),

              SizedBox(width: 16.w),

              // Planet position indicator
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Position in Solar System",
                      style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: Colors.tealAccent.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        planet.position,
                        style: TextStyle(
                          color: Colors.tealAccent,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "Distance from Sun: ${planet.distanceFromSun}",
                      style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // New method to build planet header
  Widget _buildPlanetHeader(planet) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                planet.name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                planet.type,
                style: TextStyle(color: Colors.tealAccent, fontSize: 16.sp),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.black38,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: Colors.tealAccent.withOpacity(0.5)),
            ),
            child: Row(
              children: [
                Icon(
                  planet.supportsLife ? Icons.eco : Icons.eco_outlined,
                  color:
                      planet.supportsLife ? Colors.greenAccent : Colors.white54,
                  size: 16.sp,
                ),
                SizedBox(width: 6.w),
                Text(
                  planet.supportsLife ? "Habitable" : "Uninhabitable",
                  style: TextStyle(
                    color:
                        planet.supportsLife
                            ? Colors.greenAccent
                            : Colors.white54,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedMultiLineTile(IconData icon, String content) {
    return AnimatedBuilder(
      animation: _detailsController,
      builder: (context, child) {
        // Calculate animation values
        final delay = 24 * 0.05; // After all other items
        final startInterval = delay.clamp(0.0, 0.8);
        final endInterval = (startInterval + 0.3).clamp(0.0, 1.0);

        // Calculate current animation value
        final animValue = _detailsController.value;
        double opacity = 0.0;
        double slideValue = 30.0;

        if (animValue >= startInterval) {
          opacity = (animValue - startInterval) / (endInterval - startInterval);
          if (opacity > 1.0) opacity = 1.0;
          slideValue = 30.0 * (1.0 - opacity);
        }

        return Opacity(
          opacity: opacity,
          child: Transform.translate(
            offset: Offset(0, slideValue),
            child: child,
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.white10),
          boxShadow: [
            BoxShadow(
              color: Colors.yellowAccent.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.yellowAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(icon, color: Colors.yellowAccent, size: 18.sp),
                ),
                SizedBox(width: 10.w),
                Text(
                  "Interesting Facts",
                  style: TextStyle(
                    color: Colors.yellowAccent,
                    fontSize: 14.sp,
                    fontFamily: 'SpaceGrotesk',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Text(
              content,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
                fontSize: 14.sp,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Animated section title with staggered animation based on index
  Widget _buildAnimatedSectionTitle(String text, int index) {
    return AnimatedBuilder(
      animation: _detailsController,
      builder: (context, child) {
        // Calculate animation values based on index
        final delay = index * 0.05;
        final startInterval = delay.clamp(0.0, 0.8);
        final endInterval = (startInterval + 0.2).clamp(0.0, 1.0);

        // Calculate current animation value
        final animValue = _detailsController.value;
        double opacity = 0.0;
        double slideValue = 20.0;

        if (animValue >= startInterval) {
          opacity = (animValue - startInterval) / (endInterval - startInterval);
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
      child: Container(
        margin: EdgeInsets.only(
          top: 20.h,
          bottom: 10.h,
          left: 16.w,
          right: 16.w,
        ),
        child: Row(
          children: [
            Container(
              height: 20.h,
              width: 4.w,
              decoration: BoxDecoration(
                color: Colors.tealAccent,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'SpaceGrotesk',
                shadows: [
                  Shadow(
                    color: Colors.tealAccent.withOpacity(0.3),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Container(
                height: 1.h,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
