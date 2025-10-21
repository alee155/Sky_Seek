import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sky_seek/controller/galaxy_controller.dart';
import 'package:sky_seek/widgets/earth_loader.dart';

class GalaxyDetailsScreen extends StatefulWidget {
  final String galaxyId;

  const GalaxyDetailsScreen({super.key, required this.galaxyId});

  @override
  State<GalaxyDetailsScreen> createState() => _GalaxyDetailsScreenState();
}

class _GalaxyDetailsScreenState extends State<GalaxyDetailsScreen>
    with SingleTickerProviderStateMixin {
  late final GalaxyController controller;
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _zoomAnimation;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Try to find the controller or create a new one
    try {
      controller = Get.find<GalaxyController>();
    } catch (e) {
      // If controller not found, create a new one
      controller = Get.put(GalaxyController());
      debugPrint('Created new GalaxyController as it was not found: $e');
    }

    // Setup animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();

    _rotationAnimation = Tween<double>(begin: 0, end: 2 * 3.14159).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );

    _zoomAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Using didChangeDependencies to ensure context is fully ready
    _loadGalaxyDetailsDelayed();
  }

  void _loadGalaxyDetailsDelayed() {
    // Use Future.delayed to ensure it runs after current build cycle
    Future.delayed(Duration.zero, () {
      controller.prepareGalaxyDetails(widget.galaxyId);
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
      body: GetX<GalaxyController>(
        builder: (_) {
          if (controller.isLoading.value) {
            return EarthLoader(size: 60);
          }

          if (controller.hasError.value) {
            return _buildErrorState();
          }

          if (controller.selectedGalaxy.value == null) {
            return Center(
              child: Text(
                "Galaxy data not found",
                style: TextStyle(color: Colors.white, fontSize: 18.sp),
              ),
            );
          }

          final galaxy = controller.selectedGalaxy.value!;

          return Stack(
            children: [
              CustomPaint(
                size: Size.infinite,
                painter: GalaxyParticlePainter(
                  animation: _animationController.value,
                  baseColor: Colors.blue,
                ),
              ),

              // Content
              SafeArea(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  controller: _scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with galaxy name and back button
                      Padding(
                        padding: EdgeInsets.only(
                          top: 20.h,
                          left: 16.w,
                          right: 16.w,
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => Get.back(),
                              child: Container(
                                padding: EdgeInsets.all(8.w),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black54,
                                  border: Border.all(
                                    color: Colors.blue.withOpacity(0.5),
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
                            Expanded(
                              child: Text(
                                galaxy.name,
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

                      // Large rotating galaxy image
                      _buildGalaxyImageSection(galaxy, Colors.blue),
                      SizedBox(height: 24.h),

                      // Galaxy type and constellation
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Row(
                          children: [
                            _buildInfoBadge(
                              Icons.category,
                              galaxy.type,
                              Colors.blue.withOpacity(0.7),
                            ),
                            SizedBox(width: 12.w),
                            _buildInfoBadge(
                              Icons.location_on,
                              galaxy.constellation,
                              Colors.purpleAccent.withOpacity(0.7),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // Galaxy description
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            color: Colors.black45,
                            border: Border.all(
                              color: Colors.blue.withOpacity(0.3),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.2),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "About this Galaxy",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.sp,

                                  fontFamily: 'SpaceGrotesk',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                galaxy.description,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 16.sp,
                                  height: 1.5,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // Galaxy stats section
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Text(
                          "Galaxy Statistics",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp,
                            fontFamily: 'SpaceGrotesk',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      SizedBox(height: 16.h),

                      // Stats grid
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
                              "Distance",
                              galaxy.distanceFromEarth,
                              Icons.travel_explore,
                              Colors.blue.withOpacity(0.15),
                            ),
                            _buildStatCard(
                              "Diameter",
                              galaxy.diameter,
                              Icons.straighten,
                              Colors.green.withOpacity(0.15),
                            ),
                            _buildStatCard(
                              "Stars",
                              galaxy.numberOfStars,
                              Icons.star,
                              Colors.amber.withOpacity(0.15),
                            ),
                            _buildStatCard(
                              "Discovered",
                              galaxy.discovered,
                              Icons.history,
                              Colors.deepPurple.withOpacity(0.15),
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

  Widget _buildGalaxyImageSection(galaxy, Color galaxyColor) {
    return Container(
      height: 280.h,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background glow
          Container(
            width: 220.w,
            height: 220.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: galaxyColor.withValues(alpha: 0.9),
                  blurRadius: 50,
                  spreadRadius: 20,
                ),
              ],
            ),
          ),

          // Galaxy image with rotation animation
          AnimatedBuilder(
            animation: _rotationAnimation,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotationAnimation.value,
                child: Hero(
                  tag: 'galaxy-${galaxy.id}',
                  child: Container(
                    width: 220.w,
                    height: 220.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: galaxyColor.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child:
                          galaxy.image.isNotEmpty
                              ? Image.network(
                                galaxy.image,
                                fit: BoxFit.cover,
                                loadingBuilder: (
                                  context,
                                  child,
                                  loadingProgress,
                                ) {
                                  if (loadingProgress == null) {
                                    debugPrint(
                                      "SUCCESS: Galaxy image loaded successfully",
                                    );
                                    return child;
                                  }
                                  debugPrint(
                                    "LOADING: Galaxy image loading... ${loadingProgress.expectedTotalBytes != null ? '${(loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! * 100).round()}%' : 'Unknown progress'}",
                                  );
                                  return Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  debugPrint(
                                    'ERROR: Loading galaxy image failed: $error',
                                  );
                                  debugPrint('Image URL was: ${galaxy.image}');
                                  return Container(
                                    color: galaxyColor.withOpacity(0.3),
                                    child: Center(
                                      child: Icon(
                                        Icons.blur_circular,
                                        size: 80.w,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  );
                                },
                              )
                              : Container(
                                color: galaxyColor.withOpacity(0.3),
                                child: Center(
                                  child: Icon(
                                    Icons.blur_circular,
                                    size: 80.w,
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

          // Stars around the galaxy image
          for (int i = 0; i < 8; i++)
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                final angle =
                    2 * math.pi * i / 8 +
                    _animationController.value * math.pi * 2;
                final radius = 130.w;
                final x = radius * math.cos(angle);
                final y = radius * math.sin(angle);

                return Positioned(
                  left: MediaQuery.of(context).size.width / 2 + x - 5.w,
                  top: 140.h + y - 5.w,
                  child: Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white,
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                      ],
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
    return Expanded(
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
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontFamily: 'Poppins',
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
    // Get the full color without opacity for the border
    final borderColor = Color.fromARGB(
      255, // Full opacity
      color.red,
      color.green,
      color.blue,
    );

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
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
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
            "Failed to load galaxy details",
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
            onPressed: _loadGalaxyDetailsDelayed,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.purpleAccent,
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

class GalaxyParticlePainter extends CustomPainter {
  final double animation;
  final Color baseColor;

  GalaxyParticlePainter({required this.animation, required this.baseColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white
          ..strokeWidth = 2.0
          ..strokeCap = StrokeCap.round;

    // Draw swirling particles
    for (int i = 0; i < 150; i++) {
      final radius = 20 + (i % 5) * 60 + (animation * 100) % 50;
      final angle = (i * 0.1 + animation * 2) % (2 * math.pi);
      final x = size.width / 2 + radius * math.cos(angle);
      final y = size.height / 2 + radius * math.sin(angle);

      // Alternate between white and the base color
      if (i % 3 == 0) {
        paint.color = Colors.white.withOpacity(0.2 + (i % 5) * 0.1);
      } else {
        paint.color = baseColor.withOpacity(0.1 + (i % 5) * 0.05);
      }

      final starSize = 1.0 + (i % 3) * 0.5;
      canvas.drawCircle(Offset(x, y), starSize, paint);
    }
  }

  @override
  bool shouldRepaint(GalaxyParticlePainter oldDelegate) {
    return oldDelegate.animation != animation ||
        oldDelegate.baseColor != baseColor;
  }
}
