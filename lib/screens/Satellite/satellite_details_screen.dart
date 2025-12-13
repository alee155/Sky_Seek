import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sky_seek/controller/satellite_controller.dart';

class SatelliteDetailsScreen extends StatefulWidget {
  final String satelliteId;

  const SatelliteDetailsScreen({super.key, required this.satelliteId});

  @override
  State<SatelliteDetailsScreen> createState() => _SatelliteDetailsScreenState();
}

class _SatelliteDetailsScreenState extends State<SatelliteDetailsScreen>
    with SingleTickerProviderStateMixin {
  late final SatelliteController controller;
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _orbitAnimation;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    try {
      controller = Get.find<SatelliteController>();
    } catch (e) {
      controller = Get.put(SatelliteController());
      debugPrint('Created new SatelliteController as it was not found: $e');
    }

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _rotationAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );

    _orbitAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _loadSatelliteDetailsDelayed();
  }

  void _loadSatelliteDetailsDelayed() {
    Future.delayed(Duration.zero, () {
      controller.prepareSatelliteDetails(widget.satelliteId);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GetX<SatelliteController>(
        builder: (_) {
          if (controller.isLoading.value) {
            return _buildLoadingState();
          }

          if (controller.hasError.value) {
            return _buildErrorState();
          }

          if (controller.selectedSatellite.value == null) {
            return Center(
              child: Text(
                "Satellite data not found",
                style: TextStyle(color: Colors.white, fontSize: 18.sp),
              ),
            );
          }

          final satellite = controller.selectedSatellite.value!;
          final satelliteColor = _getColorForSatellite(satellite.name);

          return Stack(
            children: [
              CustomPaint(
                size: Size.infinite,
                painter: OrbitBackgroundPainter(
                  animation: _animationController.value,
                  baseColor: satelliteColor,
                ),
              ),

              SafeArea(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  controller: _scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: 20.h,
                          left: 16.w,
                          right: 16.w,
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Container(
                                padding: EdgeInsets.all(8.w),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black54,
                                  border: Border.all(
                                    color: satelliteColor.withOpacity(0.5),
                                  ),
                                ),
                                child: Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                  size: 20.w,
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Flexible(
                              child: Text(
                                satellite.name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'SpaceGrotesk',
                                ),
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20.h),

                      _buildSatelliteVisualization(satellite, satelliteColor),

                      SizedBox(height: 24.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Row(
                          children: [
                            _buildInfoBadge(
                              Icons.category,
                              satellite.type,
                              satelliteColor.withOpacity(0.7),
                            ),
                            SizedBox(width: 12.w),
                            _buildInfoBadge(
                              Icons.flag,
                              satellite.launchedBy,
                              Colors.lightBlue.withOpacity(0.7),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 24.h),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            color: Colors.black45,
                            border: Border.all(
                              color: satelliteColor.withOpacity(0.3),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: satelliteColor.withOpacity(0.2),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "About this Satellite",
                                style: TextStyle(
                                  color: satelliteColor,
                                  fontSize: 18.sp,
                                  fontFamily: 'SpaceGrotesk',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                satellite.description,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 16.sp,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 24.h),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Text(
                          "Satellite Specifications",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp,
                            fontFamily: 'SpaceGrotesk',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      SizedBox(height: 16.h),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 16.w,
                          mainAxisSpacing: 16.h,
                          childAspectRatio: 1.5,
                          children: [
                            _buildStatCard(
                              "Launch Date",
                              satellite.launchDate,
                              Icons.calendar_today,
                              Colors.amber.withOpacity(0.15),
                            ),
                            _buildStatCard(
                              "Orbit Altitude",
                              satellite.orbitAltitude,
                              Icons.terrain,
                              Colors.blue.withOpacity(0.15),
                            ),
                            _buildStatCard(
                              "Mass",
                              satellite.mass,
                              Icons.scale,
                              Colors.green.withOpacity(0.15),
                            ),
                            _buildStatCard(
                              "Type",
                              satellite.type,
                              Icons.category,
                              Colors.purple.withOpacity(0.15),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSatelliteVisualization(satellite, Color satelliteColor) {
    return Container(
      height: 260.h,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,

              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 100,
                  spreadRadius: 15,
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset('assets/images/earth.png', fit: BoxFit.cover),
            ),
          ),
          Container(
            width: 220.w,
            height: 220.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1.w,
              ),
            ),
          ),

          AnimatedBuilder(
            animation: _orbitAnimation,
            builder: (context, child) {
              final angle = _orbitAnimation.value;
              final radius = 110.w;
              final x = radius * math.cos(angle);
              final y = radius * math.sin(angle);

              return Transform.translate(
                offset: Offset(x, y),
                child: Transform.rotate(
                  angle: _rotationAnimation.value,
                  child: Hero(
                    tag: 'satellite-${satellite.id}',
                    child: Container(
                      width: 100.w,
                      height: 100.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: satelliteColor.withOpacity(0.5),
                        //     blurRadius: 10,
                        //     spreadRadius: 2,
                        //   ),
                        // ],
                      ),
                      child: ClipOval(
                        child:
                            satellite.image.isNotEmpty
                                ? Image.network(
                                  satellite.image,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: satelliteColor.withOpacity(0.3),
                                      child: Icon(
                                        Icons.satellite_alt,
                                        size: 30.w,
                                        color: Colors.white70,
                                      ),
                                    );
                                  },
                                )
                                : Container(
                                  color: satelliteColor.withOpacity(0.3),
                                  child: Icon(
                                    Icons.satellite_alt,
                                    size: 30.w,
                                    color: Colors.white70,
                                  ),
                                ),
                      ),
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

  Widget _buildInfoBadge(IconData icon, String text, Color color) {
    return Flexible(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.r),
          color: color,
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 18.w),
            SizedBox(width: 8.w),
            Flexible(
              child: Text(
                text,
                style: TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    final borderColor = Color.fromARGB(255, color.red, color.green, color.blue);

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: color,
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, color: borderColor, size: 20.w),
              SizedBox(width: 8.w),
              Text(
                title,
                style: TextStyle(
                  color: borderColor,
                  fontSize: 14.sp,
                  fontFamily: 'SpaceGrotesk',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontFamily: 'SpaceGrotesk',
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotationAnimation.value,
                child: Container(
                  width: 120.w,
                  height: 120.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: SweepGradient(
                      colors: [
                        Colors.orange,
                        Colors.red,
                        Colors.purple,
                        Colors.blue,
                        Colors.orange,
                      ],
                      stops: [0.0, 0.25, 0.5, 0.75, 1.0],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 24.h),
          Text(
            "Loading Satellite Data...",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'SpaceGrotesk',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 60.w),
          SizedBox(height: 16.h),
          Text(
            "Failed to load satellite details",
            style: TextStyle(color: Colors.white, fontSize: 18.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            controller.errorMessage.value,
            style: TextStyle(color: Colors.white70, fontSize: 14.sp),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: _loadSatelliteDetailsDelayed,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.orange,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.r),
              ),
            ),
            child: Text("Retry"),
          ),
        ],
      ),
    );
  }

  Color _getColorForSatellite(String name) {
    if (name.toLowerCase().contains("sputnik")) {
      return Colors.orange;
    } else if (name.toLowerCase().contains("hubble")) {
      return Colors.lightBlue;
    } else if (name.toLowerCase().contains("explorer")) {
      return Colors.purple;
    } else if (name.toLowerCase().contains("voyager")) {
      return Colors.teal;
    } else if (name.toLowerCase().contains("iss")) {
      return Colors.amber;
    } else {
      final hashCode = name.hashCode;
      return Color((hashCode & 0xFFFFFF) | 0x6F000000);
    }
  }
}

class OrbitBackgroundPainter extends CustomPainter {
  final double animation;
  final Color baseColor;

  OrbitBackgroundPainter({required this.animation, required this.baseColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white
          ..strokeWidth = 2.0
          ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 100; i++) {
      final radius = (i % 5) * 1.0 + 1.0;
      final x = (i * 17 + animation * 50) % size.width;
      final y = (i * 19 + animation * 30) % size.height;

      if (i % 3 == 0) {
        paint.color = Colors.white.withOpacity(0.7);
      } else {
        paint.color = baseColor.withOpacity(0.3);
      }

      canvas.drawCircle(Offset(x, y), radius, paint);
    }

    final center = Offset(size.width / 2, size.height / 2);
    for (int i = 1; i <= 3; i++) {
      final orbitPaint =
          Paint()
            ..color = Colors.white.withOpacity(0.1)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.0;

      canvas.drawCircle(center, 100 + i * 60, orbitPaint);
    }
  }

  @override
  bool shouldRepaint(OrbitBackgroundPainter oldDelegate) {
    return oldDelegate.animation != animation ||
        oldDelegate.baseColor != baseColor;
  }
}
