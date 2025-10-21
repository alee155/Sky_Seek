import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sky_seek/controller/star_controller.dart';
import 'package:sky_seek/screens/StarDetails/star_details_screen.dart';
import 'package:sky_seek/widgets/earth_loader.dart';

class StarsListScreen extends StatefulWidget {
  final String? token;

  const StarsListScreen({super.key, this.token});

  @override
  State<StarsListScreen> createState() => _StarsListScreenState();
}

class _StarsListScreenState extends State<StarsListScreen> {
  late final StarController controller;

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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Using didChangeDependencies to ensure context is fully ready
    _loadStarsDelayed();
  }

  void _loadStarsDelayed() {
    // Use Future.delayed to ensure it runs after current build cycle
    Future.delayed(Duration.zero, () {
      _loadStars();
    });
  }

  void _loadStars() async {
    try {
      if (widget.token != null && widget.token!.isNotEmpty) {
        // First set token in controller for future use in detail screen
        controller.setToken(widget.token!);
        // Then load stars
        await controller.loadStars(widget.token!);
      } else {
        // Handle case when token is null or empty
        Future.microtask(() {
          controller.hasError.value = true;
          controller.errorMessage.value =
              'Authentication required. Please login first.';
          print('Cannot load stars: No authentication token');
        });
      }
    } catch (e) {
      print('Error loading stars: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Image
          SizedBox.expand(
            child: Image.asset('assets/images/infobg.png', fit: BoxFit.cover),
          ),

          // Custom AppBar with back button and title
          Positioned(
            top: 50.h,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => Get.back(),
                  ),
                  Text(
                    "Explore Stars",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.sp,
                      fontFamily: 'SpaceGrotesk',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Stars List
          Positioned.fill(
            top: 120.h,
            child: GetX<StarController>(
              builder: (_) {
                if (controller.isLoading.value) {
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
                          fontFamily: 'SpaceGrotesk',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  );
                }

                if (controller.hasError.value) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 60.w,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          "Failed to load stars",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontFamily: 'SpaceGrotesk',
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          controller.errorMessage.value,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14.sp,
                            fontFamily: 'SpaceGrotesk',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 24.h),
                        ElevatedButton(
                          onPressed: _loadStarsDelayed,
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

                if (controller.stars.isEmpty) {
                  return Center(
                    child: Text(
                      "No stars found",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontFamily: 'SpaceGrotesk',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }

                return GridView.builder(
                  padding: EdgeInsets.all(16.w),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.w,
                    mainAxisSpacing: 16.h,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: controller.stars.length,
                  itemBuilder: (context, index) {
                    final star = controller.stars[index];
                    return GestureDetector(
                      onTap: () {
                        // Ensure the controller already has the token before navigating
                        if (widget.token != null && widget.token!.isNotEmpty) {
                          controller.setToken(
                            widget.token!,
                          ); // Ensure token is set
                        }

                        Get.to(
                          () => StarDetailsScreen(starId: star.id),
                          transition: Transition.fadeIn,
                          duration: Duration(milliseconds: 500),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: Colors.tealAccent.withOpacity(0.3),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: _getColorForStar(
                                star.color,
                              ).withOpacity(0.2),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Star Image
                            Expanded(
                              flex: 5,
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16.r),
                                  topRight: Radius.circular(16.r),
                                ),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    gradient: RadialGradient(
                                      colors: [
                                        _getColorForStar(star.color),
                                        _getColorForStar(
                                          star.color,
                                        ).withOpacity(0.5),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      // Background color based on star color
                                      Container(
                                        color: _getColorForStar(
                                          star.color,
                                        ).withOpacity(0.3),
                                        child: Center(
                                          child: Icon(
                                            Icons.star,
                                            size: 60.w,
                                            color: _getColorForStar(star.color),
                                          ),
                                        ),
                                      ),
                                      // Image if available
                                      if (star.image.isNotEmpty)
                                        Image.network(
                                          star.image,
                                          fit: BoxFit.cover,
                                          loadingBuilder: (
                                            context,
                                            child,
                                            loadingProgress,
                                          ) {
                                            if (loadingProgress == null)
                                              return child;
                                            return SizedBox(); // Show the background color and icon
                                          },
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            // On error, just show nothing (the background will be visible)
                                            print(
                                              'Error loading grid image: $error',
                                            );
                                            return SizedBox();
                                          },
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            // Star Name
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: EdgeInsets.all(8.w),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      star.name,
                                      style: TextStyle(
                                        fontFamily: 'SpaceGrotesk',
                                        color: Colors.white,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      star.type,
                                      style: TextStyle(
                                        fontFamily: 'SpaceGrotesk',
                                        color: Colors.white70,
                                        fontSize: 12.sp,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
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
