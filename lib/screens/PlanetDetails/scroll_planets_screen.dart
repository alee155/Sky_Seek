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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
          onPressed: () => Navigator.of(context).pop(),
          color: Colors.white,
        ),
      ),
      body: Stack(
        children: [
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
                StarBackground(starCount: 300, opacity: 0.6),
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
                        _buildPlanetHeader(planet),

                        _buildPlanetImage(planet),

                        _buildAnimatedSectionTitle("Physical", 0),
                        AnimatedInfoTile(
                          icon: Icons.straighten,
                          title: "Planet",
                          value: planet.name,
                          index: 0,
                        ),
                        AnimatedInfoTile(
                          icon: Icons.straighten,
                          title: "Diameter",
                          value: planet.diameter,
                          index: 1,
                        ),
                        AnimatedInfoTile(
                          icon: Icons.public,
                          title: "Mass",
                          value: planet.mass,
                          index: 2,
                        ),
                        AnimatedInfoTile(
                          icon: Icons.compress,
                          title: "Gravity",
                          value: planet.gravity,
                          index: 3,
                        ),
                        AnimatedInfoTile(
                          icon: Icons.loop,
                          title: "Rotation Period",
                          value: planet.rotationPeriod,
                          index: 4,
                        ),
                        AnimatedInfoTile(
                          icon: Icons.access_time_filled,
                          title: "Solar Day",
                          value: planet.solarDay,
                          index: 5,
                        ),
                        AnimatedInfoTile(
                          icon: Icons.timeline,
                          title: "Orbital Period",
                          value: planet.orbitalPeriod,
                          index: 6,
                        ),
                        AnimatedInfoTile(
                          icon: Icons.circle_outlined,
                          title: "Symbol",
                          value: planet.symbol,
                          index: 7,
                        ),
                        AnimatedInfoTile(
                          icon: Icons.landscape,
                          title: "Surface",
                          value: planet.surface,
                          index: 8,
                        ),

                        _buildAnimatedSectionTitle("Orbital Properties", 9),
                        AnimatedInfoTile(
                          icon: Icons.linear_scale,
                          title: "Distance from Sun",
                          value: planet.distanceFromSun,
                          index: 10,
                        ),
                        AnimatedInfoTile(
                          icon: Icons.blur_circular,
                          title: "Eccentricity",
                          value: planet.eccentricity,
                          index: 11,
                        ),
                        AnimatedInfoTile(
                          icon: Icons.nights_stay,
                          title: "Moons",
                          value: planet.moons,
                          index: 12,
                        ),
                        AnimatedInfoTile(
                          icon: Icons.track_changes,
                          title: "Position",
                          value: planet.position,
                          index: 13,
                        ),

                        _buildAnimatedSectionTitle("Atmosphere", 14),
                        AnimatedInfoTile(
                          icon: Icons.cloud_outlined,
                          title: "Composition",
                          value: planet.atmosphereComposition,
                          index: 15,
                        ),
                        AnimatedInfoTile(
                          icon: Icons.speed,
                          title: "Pressure",
                          value: planet.atmospherePressure,
                          index: 16,
                        ),
                        AnimatedInfoTile(
                          icon: Icons.ac_unit,
                          title: "Temperature Min",
                          value: planet.temperatureMin,
                          index: 17,
                        ),
                        AnimatedInfoTile(
                          icon: Icons.local_fire_department,
                          title: "Temperature Max",
                          value: planet.temperatureMax,
                          index: 18,
                        ),

                        _buildAnimatedSectionTitle("Other Features", 19),
                        AnimatedInfoTile(
                          icon: Icons.album,
                          title: "Rings",
                          value: planet.rings ? "Yes" : "No",
                          index: 20,
                          iconColor:
                              planet.rings ? Colors.amberAccent : Colors.grey,
                        ),
                        AnimatedInfoTile(
                          icon: Icons.shield,
                          title: "Magnetic Field",
                          value: planet.magneticField ? "Yes" : "No",
                          index: 21,
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

        return Container(
          height: 120.h,
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

                  GestureDetector(
                    onTap: () async {
                      final token = await AuthService.getToken();
                      if (token != null && token.isNotEmpty) {
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

  Widget _buildPlanetImage(planet) {
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
          Row(
            children: [
              RotatingPlanet(
                imageUrl: planet.image,
                id: planet.id,
                size: 150,
                rotationDuration: Duration(seconds: 20 + (planetOrder * 3)),
                glowColor: _getPlanetGlowColor(planet),
                glowIntensity: 0.2,
              ),

              SizedBox(width: 16.w),

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
    return Container(
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
    );
  }

  Widget _buildAnimatedSectionTitle(String text, int index) {
    return Container(
      margin: EdgeInsets.only(top: 20.h, bottom: 10.h, left: 16.w, right: 16.w),
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
            child: Container(height: 1.h, color: Colors.white.withOpacity(0.1)),
          ),
        ],
      ),
    );
  }
}
