import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sky_seek/controller/profile_controller.dart';

class ProfileScreen extends StatefulWidget {
  final String token;
  const ProfileScreen({super.key, required this.token});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  final ProfileController controller = Get.put(ProfileController());

  late AnimationController _headerController;
  late Animation<Offset> _headerSlide;
  late Animation<double> _headerFade;

  late AnimationController _avatarPulseController;
  late AnimationController _fabFloatController;

  @override
  void initState() {
    super.initState();
    controller.loadProfile(widget.token);

    // Header animations
    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeOut),
    );
    _headerFade = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _headerController, curve: Curves.easeIn));

    // Avatar pulse animation
    _avatarPulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
      lowerBound: 0.9,
      upperBound: 1.1,
    )..repeat(reverse: true);

    // Floating button animation (gentle float)
    _fabFloatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    // Start header animation after slight delay
    Future.delayed(const Duration(milliseconds: 300), () {
      _headerController.forward();
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    _avatarPulseController.dispose();
    _fabFloatController.dispose();
    super.dispose();
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required int index,
    Color? accentColor,
  }) {
    // Generate a color if none provided
    final color =
        accentColor ??
        Color.fromARGB(
          255,
          150 + (index * 20).clamp(0, 105),
          100 + (index * 15).clamp(0, 155),
          200 + (index * 10).clamp(0, 55),
        );

    return AnimatedBuilder(
      animation: _headerController,
      builder: (context, child) {
        double delay = index * 0.15;
        double opacity = (_headerController.value - delay).clamp(0, 1);
        double translateY = 30 * (1 - opacity);
        return Opacity(
          opacity: opacity,
          child: Transform.translate(
            offset: Offset(0, translateY),
            child: child,
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.black.withOpacity(0.5), color.withOpacity(0.15)],
          ),
          border: Border.all(color: color.withOpacity(0.3), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Subtle star pattern
            Positioned(
              right: 10.w,
              top: 10.h,
              child: Opacity(
                opacity: 0.05,
                child: Icon(Icons.star, size: 50.w, color: color),
              ),
            ),

            // Content
            ListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 8.h,
              ),
              leading: Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      color,
                      color.withBlue((color.blue + 30).clamp(0, 255)),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.5),
                      blurRadius: 10,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 20.sp),
              ),
              title: Text(
                title,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 13.sp,
                  fontFamily: 'SpaceGrotesk',
                ),
              ),
              subtitle: Padding(
                padding: EdgeInsets.only(top: 4.h),
                child: Text(
                  value,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              trailing: Icon(
                Icons.arrow_right,
                color: color.withOpacity(0.5),
                size: 20.w,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(user) {
    return FadeTransition(
      opacity: _headerFade,
      child: SlideTransition(
        position: _headerSlide,
        child: Stack(
          children: [
            // Background glow effect
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.r),
                  boxShadow: [
                    BoxShadow(
                      color:
                          user.gender.toLowerCase() == 'female'
                              ? Colors.pink.withOpacity(0.2)
                              : Colors.blue.withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ),

            // Main content container with glass effect
            ClipRRect(
              borderRadius: BorderRadius.circular(25.r),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        user.gender.toLowerCase() == 'female'
                            ? Colors.purple.withOpacity(0.15)
                            : Colors.indigo.withOpacity(0.15),
                        Colors.black.withOpacity(0.2),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(25.r),
                    border: Border.all(
                      color:
                          user.gender.toLowerCase() == 'female'
                              ? Colors.pinkAccent.withOpacity(0.3)
                              : Colors.blueAccent.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Avatar with orbit ring
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          // Orbit ring
                          Container(
                            width: 95.r,
                            height: 95.r,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color:
                                    user.gender.toLowerCase() == 'female'
                                        ? Colors.pinkAccent.withOpacity(0.6)
                                        : Colors.blueAccent.withOpacity(0.6),
                                width: 2,
                              ),
                            ),
                          ),
                          // Avatar image
                          ScaleTransition(
                            scale: _avatarPulseController,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        user.gender.toLowerCase() == 'female'
                                            ? Colors.pink.withOpacity(0.4)
                                            : Colors.blue.withOpacity(0.4),
                                    blurRadius: 15,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 38.r,
                                backgroundColor: Colors.white.withOpacity(0.1),
                                backgroundImage: AssetImage(
                                  user.gender.toLowerCase() == 'female'
                                      ? 'assets/images/female.png'
                                      : 'assets/images/male.png',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 15.h),

                      // User name with cosmos icon
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            user.gender.toLowerCase() == 'female'
                                ? Icons.auto_awesome
                                : Icons.public,
                            color:
                                user.gender.toLowerCase() == 'female'
                                    ? Colors.pinkAccent
                                    : Colors.blueAccent,
                            size: 18.w,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            "${user.firstName} ${user.lastName}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 6.h),

                      // Email with cosmic theme
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.mail_outline,
                            color: Colors.grey[400],
                            size: 14.w,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            user.email,
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 12.h),

                      // Explorer badge
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color:
                              user.gender.toLowerCase() == 'female'
                                  ? Colors.pinkAccent.withOpacity(0.2)
                                  : Colors.blueAccent.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(30.r),
                          border: Border.all(
                            color:
                                user.gender.toLowerCase() == 'female'
                                    ? Colors.pinkAccent.withOpacity(0.4)
                                    : Colors.blueAccent.withOpacity(0.4),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.rocket_launch,
                              color:
                                  user.gender.toLowerCase() == 'female'
                                      ? Colors.pinkAccent
                                      : Colors.blueAccent,
                              size: 16.w,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'Space Explorer',
                              style: TextStyle(
                                color:
                                    user.gender.toLowerCase() == 'female'
                                        ? Colors.pinkAccent
                                        : Colors.blueAccent,
                                fontSize: 14.sp,
                                fontFamily: 'SpaceGrotesk',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingLogoutButton() {
    return AnimatedBuilder(
      animation: _fabFloatController,
      builder: (context, child) {
        final double offsetY =
            5 * (1 - (0.5 - (_fabFloatController.value - 0.5).abs()) * 2);
        return Transform.translate(offset: Offset(0, -offsetY), child: child);
      },
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  backgroundColor: Colors.grey[900],
                  title: const Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'SpaceGrotesk',
                    ),
                  ),
                  content: const Text(
                    'Are you sure you want to logout?',
                    style: TextStyle(
                      color: Colors.white70,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.blue,
                          fontFamily: 'SpaceGrotesk',
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        controller.logout();
                      },
                      child: const Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.red,
                          fontFamily: 'SpaceGrotesk',
                        ),
                      ),
                    ),
                  ],
                ),
          );
        },
        child: Container(
          width: 55.w,
          height: 55.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFFFF4E50), Color(0xFFB71C1C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.9),
                blurRadius: 50,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Icons.logout, color: Colors.white, size: 26),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: _buildFloatingLogoutButton(),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/profile.png',
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.6),
              colorBlendMode: BlendMode.darken,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 60.w,
                          height: 60.w,
                          child: CircularProgressIndicator(
                            color: Colors.blueAccent,
                            backgroundColor: Colors.blueAccent.withOpacity(0.2),
                            strokeWidth: 5,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          "Loading your cosmic profile...",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final user = controller.profile.value;
                if (user == null) {
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
                          "Failed to load profile",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        ElevatedButton(
                          onPressed: () => controller.loadProfile(widget.token),
                          child: Text("Retry"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProfileHeader(user),

                      SizedBox(height: 25.h),
                      FadeTransition(
                        opacity: _headerFade,
                        child: Row(
                          children: [
                            Icon(
                              Icons.person,
                              color:
                                  user.gender.toLowerCase() == 'female'
                                      ? Colors.pinkAccent
                                      : Colors.blueAccent,
                              size: 18.w,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              "Profile Details",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 12.h),

                      // Info cards
                      _buildInfoCard(
                        icon: Icons.person,
                        title: "First Name",
                        value: user.firstName,
                        index: 0,
                        accentColor:
                            user.gender.toLowerCase() == 'female'
                                ? Colors.pinkAccent
                                : Colors.blueAccent,
                      ),
                      _buildInfoCard(
                        icon: Icons.person_outline,
                        title: "Last Name",
                        value: user.lastName,
                        index: 1,
                        accentColor:
                            user.gender.toLowerCase() == 'female'
                                ? Colors.purpleAccent
                                : Colors.cyanAccent,
                      ),
                      _buildInfoCard(
                        icon:
                            user.gender.toLowerCase() == 'female'
                                ? Icons.woman
                                : Icons.man,
                        title: "Gender",
                        value: user.gender,
                        index: 2,
                        accentColor:
                            user.gender.toLowerCase() == 'female'
                                ? Colors.pink
                                : Colors.blue,
                      ),
                      _buildInfoCard(
                        icon: Icons.email,
                        title: "Email",
                        value: user.email,
                        index: 3,
                        accentColor: Colors.teal,
                      ),

                      SizedBox(height: 80.h),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
