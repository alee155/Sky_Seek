import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sky_seek/controller/satellite_controller.dart';
import 'package:sky_seek/models/satellite_model.dart';
import 'package:sky_seek/screens/Satellite/satellite_details_screen.dart';
import 'package:sky_seek/widgets/earth_loader.dart';

class SatelliteScreen extends StatefulWidget {
  const SatelliteScreen({super.key});

  @override
  State<SatelliteScreen> createState() => _SatelliteScreenState();
}

class _SatelliteScreenState extends State<SatelliteScreen>
    with SingleTickerProviderStateMixin {
  late final SatelliteController controller;
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

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
      duration: const Duration(milliseconds: 1500),
    )..forward();

    _slideAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutQuart),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          CustomPaint(size: Size.infinite, painter: SpaceBackgroundPainter()),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 16.h,
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
                              color: const Color(0xFFE65100).withOpacity(0.5),
                            ),
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 20.w,
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Text(
                        "Earth's Satellites",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SpaceGrotesk',
                        ),
                      ),
                    ],
                  ),
                ),

                Flexible(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return _buildLoadingState();
                    }

                    if (controller.hasError.value) {
                      return _buildErrorState();
                    }

                    if (controller.satellites.isEmpty) {
                      return Center(
                        child: Text(
                          "No satellites found",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontFamily: 'SpaceGrotesk',
                          ),
                        ),
                      );
                    }

                    return _buildSatelliteList(controller.satellites);
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSatelliteList(List<Satellite> satellites) {
    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return ListView.builder(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          itemCount: satellites.length,
          itemBuilder: (context, index) {
            final satellite = satellites[index];

            final delayedAnimation = _slideAnimation.value - (index * 0.1);
            final offsetValue = delayedAnimation.clamp(0.0, 1.0);

            return Transform.translate(
              offset: Offset(offsetValue * 200, 0),
              child: AnimatedOpacity(
                duration: Duration.zero,
                opacity: 1.0 - offsetValue,
                child: GestureDetector(
                  onTap: () {
                    Get.to(
                      () => SatelliteDetailsScreen(satelliteId: satellite.id),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 16.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFE65100).withOpacity(0.8),
                          Color(0xFF3E2723).withOpacity(0.6),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFE65100).withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                      border: Border.all(
                        color: Color(0xFFE65100).withOpacity(0.5),
                        width: 1.5,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.r),
                      child: Stack(
                        children: [
                          _buildShineEffect(),

                          Padding(
                            padding: EdgeInsets.all(12.w),
                            child: Row(
                              children: [
                                Hero(
                                  tag: 'satellite-${satellite.id}',
                                  child: Container(
                                    width: 90.w,
                                    height: 90.w,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white.withOpacity(0.3),
                                          blurRadius: 10,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: ClipOval(
                                      child:
                                          satellite.image.isNotEmpty
                                              ? Image.network(
                                                satellite.image,
                                                fit: BoxFit.cover,
                                                errorBuilder: (
                                                  context,
                                                  error,
                                                  stackTrace,
                                                ) {
                                                  return Container(
                                                    color: Colors.grey[800],
                                                    child: Icon(
                                                      Icons.satellite_alt,
                                                      color: Colors.white70,
                                                      size: 40.w,
                                                    ),
                                                  );
                                                },
                                              )
                                              : Container(
                                                color: Colors.grey[800],
                                                child: Icon(
                                                  Icons.satellite_alt,
                                                  color: Colors.white70,
                                                  size: 40.w,
                                                ),
                                              ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16.w),

                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        satellite.name,
                                        style: TextStyle(
                                          fontFamily: 'SpaceGrotesk',
                                          color: Colors.white,
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 4.h),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.category,
                                            color: Colors.white70,
                                            size: 14.w,
                                          ),
                                          SizedBox(width: 4.w),
                                          Flexible(
                                            child: Text(
                                              satellite.type,
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                color: Colors.white70,
                                                fontSize: 14.sp,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 4.h),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.calendar_today,
                                            color: Colors.white70,
                                            size: 14.w,
                                          ),
                                          SizedBox(width: 4.w),
                                          Flexible(
                                            child: Text(
                                              "Launched: ${satellite.launchDate}",
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                color: Colors.white70,
                                                fontSize: 14.sp,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 4.h),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.flag,
                                            color: Colors.white70,
                                            size: 14.w,
                                          ),
                                          SizedBox(width: 4.w),
                                          Flexible(
                                            child: Text(
                                              "By: ${satellite.launchedBy}",
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                color: Colors.white70,
                                                fontSize: 14.sp,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                Icon(
                                  Icons.chevron_right,
                                  color: Colors.white,
                                  size: 24.w,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildShineEffect() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.0),
                Colors.white.withOpacity(0.1 * _animationController.value),
                Colors.white.withOpacity(0.0),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return Column(
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
            "Failed to load satellites",
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
            onPressed: controller.fetchSatellites,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xFFE65100),
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
}

class SpaceBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    final random = DateTime.now().millisecondsSinceEpoch;

    for (int i = 0; i < 200; i++) {
      final x = ((random * (i + 1)) % size.width).toDouble();
      final y = ((random * (i + 3)) % size.height).toDouble();
      final radius = ((random * (i + 5)) % 3 + 1) * 0.5;

      if (i % 10 == 0) {
        final glowPaint =
            Paint()
              ..color = Colors.white.withOpacity(0.5)
              ..maskFilter = MaskFilter.blur(BlurStyle.normal, 3.0);
        canvas.drawCircle(Offset(x, y), radius * 2, glowPaint);
      }

      canvas.drawCircle(Offset(x, y), radius, paint);
    }

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final gradient = RadialGradient(
      center: Alignment.center,
      radius: 1.0,
      colors: [Color(0xFF1A237E).withOpacity(0.4), Colors.black],
      stops: const [0.0, 1.0],
    );

    final backgroundPaint = Paint()..shader = gradient.createShader(rect);
    canvas.drawRect(rect, backgroundPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
