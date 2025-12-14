import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sky_seek/controller/galaxy_controller.dart';
import 'package:sky_seek/screens/GalaxyDetails/galaxy_details_screen.dart';
import 'package:sky_seek/widgets/earth_loader.dart';

class GalaxiesListScreen extends StatefulWidget {
  final String? token;

  const GalaxiesListScreen({super.key, this.token});

  @override
  State<GalaxiesListScreen> createState() => _GalaxiesListScreenState();
}

class _GalaxiesListScreenState extends State<GalaxiesListScreen>
    with SingleTickerProviderStateMixin {
  late final GalaxyController controller;
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    // Setup animation controllers
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 100),
    )..repeat();

    _rotationAnimation = Tween<double>(begin: 0, end: 2 * 3.14159).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );

    // Try to find the controller or create a new one
    try {
      controller = Get.find<GalaxyController>();
    } catch (e) {
      // If controller not found, create a new one
      controller = Get.put(GalaxyController());
      debugPrint('Created new GalaxyController as it was not found: $e');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Using didChangeDependencies to ensure context is fully ready
    _loadGalaxiesDelayed();
  }

  void _loadGalaxiesDelayed() {
    // Use Future.delayed to ensure it runs after current build cycle
    Future.delayed(Duration.zero, () {
      _loadGalaxies();
    });
  }

  void _loadGalaxies() async {
    try {
      if (widget.token != null && widget.token!.isNotEmpty) {
        // First set token in controller for future use in detail screen
        controller.setToken(widget.token!);
        // Then load galaxies
        await controller.loadGalaxies(widget.token!);
      } else {
        // Handle case when token is null or empty
        Future.microtask(() {
          controller.hasError.value = true;
          controller.errorMessage.value =
              'Authentication required. Please login first.';
          debugPrint('Cannot load galaxies: No authentication token');
        });
      }
    } catch (e) {
      debugPrint('Error loading galaxies: $e');
    }
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
          // Space background
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/infobg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Animated galaxy particles
          _buildParticleBackground(),

          // Header
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(top: 20.h, left: 20.w, right: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Text(
                        "Explore Galaxies",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SpaceGrotesk',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Padding(
                    padding: EdgeInsets.only(left: 16.w),
                    child: Text(
                      "Discover the cosmic structures of our universe",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14.sp,
                        fontFamily: 'Poppins',
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Galaxies Content
          Positioned.fill(
            top: 140.h,
            child: GetX<GalaxyController>(
              builder: (_) {
                if (controller.isLoading.value) {
                  return _buildLoadingState();
                }

                if (controller.hasError.value) {
                  return _buildErrorState();
                }

                if (controller.galaxies.isEmpty) {
                  return Center(
                    child: Text(
                      "No galaxies found",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontFamily: 'SpaceGrotesk',
                      ),
                    ),
                  );
                }

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: controller.galaxies.length,
                    itemBuilder: (context, index) {
                      final galaxy = controller.galaxies[index];
                      return _buildGalaxyCard(galaxy, context);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGalaxyCard(galaxy, BuildContext context) {
    // Generate a unique color based on galaxy name

    return GestureDetector(
      onTap: () {
        // Ensure the controller already has the token before navigating
        if (widget.token != null && widget.token!.isNotEmpty) {
          controller.setToken(widget.token!); // Ensure token is set
        }

        Get.to(
          () => GalaxyDetailsScreen(galaxyId: galaxy.id),
          transition: Transition.fadeIn,
          duration: Duration(milliseconds: 300),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 12.h),
        height: 180.h,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                margin: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(20),
                ),
                clipBehavior: Clip.hardEdge,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(color: Colors.black.withOpacity(0.3)),

                    galaxy.image.isNotEmpty
                        ? Image.network(
                          galaxy.image,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            debugPrint('Error loading galaxy image: $error');
                            return Icon(
                              Icons.blur_circular,
                              size: 60.w,
                              color: Colors.white70,
                            );
                          },
                        )
                        : Icon(
                          Icons.blur_circular,
                          size: 60.w,
                          color: Colors.white70,
                        ),
                  ],
                ),
              ),
            ),

            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      galaxy.name,
                      style: TextStyle(
                        fontFamily: 'SpaceGrotesk',
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8.h),
                    _buildInfoRow(Icons.category, galaxy.type),
                    SizedBox(height: 4.h),
                    _buildInfoRow(Icons.location_on, galaxy.constellation),
                    SizedBox(height: 4.h),
                    _buildInfoRow(Icons.straighten, galaxy.diameter),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Icon(Icons.explore, color: Colors.white70, size: 16.w),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            "Tap to explore",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12.sp,
                              fontFamily: 'Poppins',
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 16.w),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.white,
              fontSize: 14.sp,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
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
            fontFamily: 'Poppins',
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
            "Failed to map the cosmos",
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
            onPressed: _loadGalaxiesDelayed,
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

  Widget _buildParticleBackground() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: ParticlePainter(animation: _animationController.value),
        );
      },
    );
  }
}

class ParticlePainter extends CustomPainter {
  final double animation;

  ParticlePainter({required this.animation});

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final paint =
        Paint()
          ..color = Colors.white
          ..strokeWidth = 2.0
          ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 100; i++) {
      final x = (i * 7.3 + animation * 100) % canvasSize.width;
      final y = (i * 9.7 + animation * 80) % canvasSize.height;
      final opacity = (0.3 + (animation * 3 + i) % 0.7);
      final starSize = 1.0 + ((animation * 5 + i) % 2.0);

      paint.color = Colors.white.withOpacity(opacity);
      canvas.drawCircle(Offset(x, y), starSize, paint);
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}
