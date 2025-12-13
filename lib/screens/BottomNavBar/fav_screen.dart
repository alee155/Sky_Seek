import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sky_seek/controller/favorite_controller.dart';
import 'package:sky_seek/models/planet_model.dart';
import 'package:sky_seek/services/auth_service.dart';
import 'package:sky_seek/widgets/earth_loader.dart';

class MyFavoritScreen extends StatefulWidget {
  final String? token;

  const MyFavoritScreen({super.key, this.token});

  @override
  State<MyFavoritScreen> createState() => _MyFavoritScreenState();
}

class _MyFavoritScreenState extends State<MyFavoritScreen> {
  final FavoriteController controller = Get.put(FavoriteController());

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    String? token = widget.token;
    if (token == null || token.isEmpty) {
      token = await AuthService.getToken();
    }

    if (token != null && token.isNotEmpty) {
      await controller.loadFavoritePlanets(token);
    } else {
      controller.hasError.value = true;
      controller.errorMessage.value = 'Please login to view favorite planets';
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
        title: Row(
          children: [
            Text(
              'My Favorite Planets',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontFamily: 'SpaceGrotesk',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          Obx(
            () =>
                controller.isLoading.value
                    ? Container(
                      padding: EdgeInsets.all(8.w),
                      width: 40.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.transparent,
                        ),
                      ),
                    )
                    : IconButton(
                      icon: Icon(Icons.refresh, color: Colors.tealAccent),
                      onPressed: _loadFavorites,
                      tooltip: 'Refresh favorites',
                    ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SizedBox.expand(
            child: Stack(
              children: [
                Image.asset(
                  'assets/images/infobg.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),

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

          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Obx(() {
                if (controller.isLoading.value &&
                    controller.favoritePlanets.isEmpty) {
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
                    child: Container(
                      padding: EdgeInsets.all(24.w),
                      margin: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: Colors.redAccent.withOpacity(0.5),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.redAccent,
                            size: 60.sp,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'Houston, we have a problem!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.sp,
                              fontFamily: 'SpaceGrotesk',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            controller.errorMessage.value,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16.sp,
                              fontFamily: 'SpaceGrotesk',
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 24.h),
                          ElevatedButton.icon(
                            onPressed: _loadFavorites,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: 24.w,
                                vertical: 12.h,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.r),
                              ),
                            ),
                            icon: Icon(Icons.refresh),
                            label: Text(
                              'Try Again',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontFamily: 'SpaceGrotesk',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (controller.favoritePlanets.isEmpty) {
                  return Center(
                    child: Container(
                      padding: EdgeInsets.all(24.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 140.w,
                                height: 140.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white24,
                                    width: 1,
                                  ),
                                ),
                              ),
                              Container(
                                width: 100.w,
                                height: 100.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black.withOpacity(0.3),
                                  border: Border.all(
                                    color: Colors.white24,
                                    width: 1,
                                  ),
                                ),
                                child: Icon(
                                  Icons.favorite_border,
                                  color: Colors.white70,
                                  size: 50.sp,
                                ),
                              ),
                              // Add some star elements around
                              Positioned(
                                top: 10.h,
                                right: 30.w,
                                child: Icon(
                                  Icons.star,
                                  color: Colors.yellow.withOpacity(0.7),
                                  size: 14.sp,
                                ),
                              ),
                              Positioned(
                                bottom: 20.h,
                                left: 20.w,
                                child: Icon(
                                  Icons.star,
                                  color: Colors.yellow.withOpacity(0.5),
                                  size: 12.sp,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24.h),
                          Text(
                            'Your Cosmic Collection is Empty',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.sp,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'SpaceGrotesk',
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            'You haven\'t added any planets to your favorites yet. Explore the universe and mark planets you love!',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16.sp,
                              height: 1.5,
                              fontFamily: 'Poppins',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.only(top: 16.h, bottom: 24.h),
                  itemCount: controller.favoritePlanets.length,
                  itemBuilder: (context, index) {
                    final planet = controller.favoritePlanets[index];
                    return _buildPlanetCard(planet);
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanetCard(Planet planet) {
    final positionRegex = RegExp(r'(\d+)');
    final match = positionRegex.firstMatch(planet.position);
    int planetOrder =
        match != null ? (int.tryParse(match.group(0) ?? '0') ?? 0) : 0;

    List<Color> cardGradient;
    if (planet.type.toLowerCase().contains('gas')) {
      cardGradient = [
        Colors.indigo.withOpacity(0.7),
        Colors.purple.withOpacity(0.7),
      ];
    } else if (planet.type.toLowerCase().contains('ice')) {
      cardGradient = [
        Colors.lightBlue.withOpacity(0.7),
        Colors.blue.withOpacity(0.7),
      ];
    } else if (planet.type.toLowerCase().contains('terrestrial')) {
      cardGradient = [
        Colors.teal.withOpacity(0.7),
        Colors.green.withOpacity(0.7),
      ];
    } else {
      cardGradient = [
        Colors.grey.withOpacity(0.7),
        Colors.blueGrey.withOpacity(0.7),
      ];
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 4.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: cardGradient[0].withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.5),
                ],
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: -30.w,
                  top: 20.h,
                  bottom: 20.h,
                  child: Container(
                    width: 100.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.05),
                        width: 1,
                      ),
                    ),
                  ),
                ),

                Row(
                  children: [
                    Container(
                      width: 120.w,
                      height: 120.h,
                      padding: EdgeInsets.all(12.w),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: cardGradient[0].withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                          ),

                          Container(
                            width: 90.w,
                            height: 90.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: cardGradient[1].withOpacity(0.5),
                                width: 1,
                              ),
                            ),
                          ),

                          Container(
                            width: 80.w,
                            height: 80.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: cardGradient[0].withOpacity(0.4),
                                  blurRadius: 15,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child:
                                  planet.image.isNotEmpty
                                      ? Image.network(
                                        planet.image,
                                        fit: BoxFit.cover,
                                        loadingBuilder: (
                                          context,
                                          child,
                                          loadingProgress,
                                        ) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value:
                                                  loadingProgress
                                                              .expectedTotalBytes !=
                                                          null
                                                      ? loadingProgress
                                                              .cumulativeBytesLoaded /
                                                          loadingProgress
                                                              .expectedTotalBytes!
                                                      : null,
                                              color: Colors.tealAccent,
                                              strokeWidth: 2,
                                            ),
                                          );
                                        },
                                        errorBuilder: (
                                          context,
                                          error,
                                          stackTrace,
                                        ) {
                                          return Container(
                                            color: cardGradient[0].withOpacity(
                                              0.2,
                                            ),
                                            child: Icon(
                                              Icons.public,
                                              color: Colors.white70,
                                              size: 30.sp,
                                            ),
                                          );
                                        },
                                      )
                                      : Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: cardGradient,
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.public,
                                          color: Colors.white,
                                          size: 30.sp,
                                        ),
                                      ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 16.h, 16.w, 16.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    planet.name,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'SpaceGrotesk',
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => _removeFavorite(planet.id),
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.redAccent,
                                    size: 20.sp,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 6.h),

                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 3.h,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                color: cardGradient[0].withOpacity(0.3),
                              ),
                              child: Text(
                                planet.type,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'SpaceGrotesk',
                                ),
                              ),
                            ),
                            SizedBox(height: 12.h),

                            Container(
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                color: Colors.black26,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildDetailRow(
                                    icon: Icons.public,
                                    label: "Position",
                                    value: planet.position,
                                  ),

                                  _buildDetailRow(
                                    icon: Icons.straighten,
                                    label: "Distance",
                                    value: planet.distanceFromSun,
                                  ),

                                  if (planet.moons != "0")
                                    _buildDetailRow(
                                      icon: Icons.brightness_2,
                                      label: "Moons",
                                      value: planet.moons,
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                if (planet.supportsLife)
                  Positioned(
                    bottom: 10.h,
                    right: 10.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.eco, color: Colors.white, size: 14.sp),
                          SizedBox(width: 4.w),
                          Text(
                            'Habitable',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.h),
      child: Row(
        children: [
          Icon(icon, size: 14.sp, color: Colors.white70),
          SizedBox(width: 6.w),
          Text(
            "$label: ",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12.sp,
              fontFamily: 'SpaceGrotesk',
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _removeFavorite(String planetId) async {
    try {
      String? token = widget.token;
      if (token == null || token.isEmpty) {
        token = await AuthService.getToken();
      }

      if (token != null && token.isNotEmpty) {
        final result = await controller.removeFavorite(token, planetId);

        if (result['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                result['message'] ?? 'Planet removed from favorites',
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                result['message'] ?? 'Failed to remove planet from favorites',
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please login to remove favorites'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error removing favorite: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
