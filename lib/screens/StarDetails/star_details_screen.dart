import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sky_seek/controller/star_controller.dart';
import 'package:sky_seek/widgets/star_background.dart';

class StarDetailsScreen extends StatefulWidget {
  final String starId;

  const StarDetailsScreen({super.key, required this.starId});

  @override
  State<StarDetailsScreen> createState() => _StarDetailsScreenState();
}

class _StarDetailsScreenState extends State<StarDetailsScreen>
    with SingleTickerProviderStateMixin {
  late final StarController controller;
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Try to find the controller or create a new one
    try {
      controller = Get.find<StarController>();
    } catch (e) {
      // If controller not found, create a new one
      controller = Get.put(StarController());
      print('Created new StarController as it was not found: $e');
    }

    // Setup animations first to avoid null errors
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Using didChangeDependencies to ensure context is fully ready
    // and avoid triggering a rebuild during build phase
    _loadStarDetailsDelayed();
  }

  void _loadStarDetailsDelayed() {
    // Use Future.delayed to ensure it runs after current build cycle
    Future.delayed(Duration.zero, () {
      controller.prepareStarDetails(widget.starId);
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
      body: Stack(
        children: [
          // Animated star background
          Positioned.fill(
            child: Opacity(opacity: 0.7, child: StarBackground(starCount: 200)),
          ),

          // Content - Using GetX widget instead of Obx for better control
          GetX<StarController>(
            builder: (_) {
              if (controller.isLoading.value) {
                return _buildLoadingState();
              }

              if (controller.hasError.value) {
                return _buildErrorState();
              }

              if (controller.selectedStar.value == null) {
                return Center(
                  child: Text(
                    "Star not found",
                    style: TextStyle(color: Colors.white, fontSize: 18.sp),
                  ),
                );
              }

              // Create a local copy of the star to prevent state modifications during build
              final star = controller.selectedStar.value!;

              return CustomScrollView(
                controller: _scrollController,
                physics: BouncingScrollPhysics(),
                slivers: [
                  // App Bar with star name
                  SliverAppBar(
                    expandedHeight: 300.h,
                    floating: false,
                    pinned: true,
                    iconTheme: const IconThemeData(color: Colors.white),
                    backgroundColor: Colors.black.withOpacity(0.6),
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(
                        star.name,
                        style: TextStyle(
                          fontFamily: 'SpaceGrotesk',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              blurRadius: 10,
                              color: _getColorForStar(star.color),
                            ),
                          ],
                        ),
                      ),
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Star image with color overlay
                          star.image.isNotEmpty
                              ? Stack(
                                fit: StackFit.expand,
                                children: [
                                  // Background color based on star type while image loads
                                  Container(
                                    color: _getColorForStar(
                                      star.color,
                                    ).withOpacity(0.3),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        backgroundColor: Colors.transparent,
                                      ),
                                    ),
                                  ),
                                  // Actual image - with debug information
                                  Image.network(
                                    star.image,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (
                                      context,
                                      child,
                                      loadingProgress,
                                    ) {
                                      if (loadingProgress == null) {
                                        debugPrint(
                                          "SUCCESS: Star image loaded successfully",
                                        );
                                        return child;
                                      }
                                      debugPrint(
                                        "LOADING: Star image loading... ${loadingProgress.expectedTotalBytes != null ? '${(loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! * 100).round()}%' : 'Unknown progress'}",
                                      );
                                      return SizedBox(); // Show the background color and spinner
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      debugPrint(
                                        'ERROR: Loading star image failed: $error',
                                      );
                                      debugPrint(
                                        'Image URL was: ${star.image}',
                                      );
                                      return _buildStarVisual(star);
                                    },
                                  ),
                                ],
                              )
                              : _buildStarVisual(star),

                          // Gradient overlay
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.8),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Main content
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Star type and class
                          _buildInfoRow(
                            icon: Icons.category,
                            title: "Star Type",
                            value: "${star.type} | Class ${star.spectralClass}",
                            iconColor: _getColorForStar(star.color),
                          ),

                          // Quick stats in horizontal row
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 16.h),
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: _getColorForStar(
                                  star.color,
                                ).withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildStatItem(
                                  icon: Icons.thermostat,
                                  label: "Temp",
                                  value: star.surfaceTemperature,
                                  color: Colors.orangeAccent,
                                ),
                                _buildStatItem(
                                  icon: Icons.radio_button_unchecked,
                                  label: "Size",
                                  value: star.radius,
                                  color: Colors.blueAccent,
                                ),
                                _buildStatItem(
                                  icon: Icons.scale,
                                  label: "Mass",
                                  value: star.mass,
                                  color: Colors.purpleAccent,
                                ),
                              ],
                            ),
                          ),

                          // Description
                          if (star.description.isNotEmpty) ...[
                            _buildSectionTitle("Overview"),
                            Container(
                              margin: EdgeInsets.only(bottom: 16.h),
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.1),
                                ),
                              ),
                              child: Text(
                                star.description,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 16.sp,

                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],

                          // Details section
                          _buildSectionTitle("Stellar Details"),
                          _buildDetailItem(
                            title: "Distance from Earth",
                            value: star.distanceFromEarth,
                          ),
                          // Only show fields that have values
                          if (star.luminosity.isNotEmpty)
                            _buildDetailItem(
                              title: "Luminosity",
                              value: star.luminosity,
                            ),
                          if (star.mass.isNotEmpty)
                            _buildDetailItem(title: "Mass", value: star.mass),
                          if (star.age.isNotEmpty)
                            _buildDetailItem(title: "Age", value: star.age),
                          if (star.constellation.isNotEmpty)
                            _buildDetailItem(
                              title: "Constellation",
                              value: star.constellation,
                            ),
                          if (star.spectralClass.isNotEmpty)
                            _buildDetailItem(
                              title: "Spectral Class",
                              value: star.spectralClass,
                            ),
                          if (star.hasExoplanets)
                            _buildDetailItem(
                              title: "Has Exoplanets",
                              value: "Yes",
                            ),

                          // Trivia section
                          if (star.trivia.isNotEmpty) ...[
                            SizedBox(height: 16.h),
                            _buildSectionTitle("Did You Know?"),
                            Container(
                              margin: EdgeInsets.only(bottom: 24.h),
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                color: _getColorForStar(
                                  star.color,
                                ).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(
                                  color: _getColorForStar(
                                    star.color,
                                  ).withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.lightbulb_outline,
                                    color: _getColorForStar(star.color),
                                    size: 24.w,
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Text(
                                      star.trivia,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.9),
                                        fontSize: 16.sp,
                                        height: 1.5,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],

                          SizedBox(height: 24.h),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  // Loading state with animated shimmer effect
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 80.w,
            height: 80.w,
            child: CircularProgressIndicator(
              color: Colors.tealAccent,
              backgroundColor: Colors.tealAccent.withOpacity(0.2),
              strokeWidth: 6.w,
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            "Loading Star Data...",
            style: TextStyle(color: Colors.white, fontSize: 18.sp),
          ),
        ],
      ),
    );
  }

  // Error state
  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 60.w),
          SizedBox(height: 16.h),
          Text(
            "Failed to load star details",
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
            onPressed: _loadStarDetailsDelayed,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.tealAccent,
            ),
            child: Text("Retry"),
          ),
        ],
      ),
    );
  }

  // Visualize a star when no image is available
  Widget _buildStarVisual(star) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 0.8,
          colors: [
            _getColorForStar(star.color),
            _getColorForStar(star.color).withOpacity(0.5),
            Colors.black,
          ],
          stops: [0.2, 0.6, 1.0],
        ),
      ),
      child: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                width: 120.w,
                height: 120.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _getColorForStar(star.color),
                      blurRadius: 50,
                      spreadRadius: 10,
                    ),
                  ],
                  gradient: RadialGradient(
                    colors: [Colors.white, _getColorForStar(star.color)],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Section title with animated underline
  Widget _buildSectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 8.h, top: 8.h),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontFamily: 'SpaceGrotesk',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          width: 60.w,
          height: 3.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.tealAccent, Colors.transparent],
            ),
            borderRadius: BorderRadius.circular(1.5.h),
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }

  // Info row with icon
  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
    required Color iconColor,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 20.w),
          SizedBox(width: 12.w),
          Text(
            title,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14.sp,
              fontFamily: 'SpaceGrotesk',
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  // Stat item for quick stats row
  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24.w),
        SizedBox(height: 8.h),
        Text(label, style: TextStyle(color: Colors.white70, fontSize: 12.sp)),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // Detail item for specifications list
  Widget _buildDetailItem({required String title, required String value}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
        ),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Align to top for wrapping
        children: [
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: TextStyle(color: Colors.white70, fontSize: 15.sp),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            flex: 5,
            child: Text(
              value,
              textAlign: TextAlign.right,
              softWrap: true,
              overflow: TextOverflow.visible,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to get color based on star color name
  Color _getColorForStar(String color) {
    switch (color.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'yellow':
        return Colors.yellow;
      case 'white':
        return Colors.white;
      case 'orange':
        return Colors.orange;
      default:
        return Colors.tealAccent; // Default color
    }
  }
}
