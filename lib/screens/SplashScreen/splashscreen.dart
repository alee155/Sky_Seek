import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sky_seek/Auth/login_screen.dart';
import 'package:sky_seek/screens/BottomNavBar/bottomnavbar_screen.dart';
import 'package:sky_seek/services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<Offset> _satelliteSlideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _satelliteSlideAnimation = Tween<Offset>(
      begin: const Offset(0.5, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();

    // Check auth status and navigate accordingly
    _checkAuthAndNavigate();
  }

  void _checkAuthAndNavigate() async {
    try {
      // Wait for animations to complete
      await Future.delayed(const Duration(seconds: 3));

      // Test shared preferences first
      final sharedPrefsWorking = await AuthService.testSharedPreferences();
      print('Shared Preferences Working: $sharedPrefsWorking');

      if (!sharedPrefsWorking) {
        // If shared_preferences is not working, go to login screen
        Get.snackbar(
          "Warning",
          "Session storage isn't working properly. You might need to login again when restarting the app.",
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: Duration(seconds: 5),
          snackPosition: SnackPosition.BOTTOM,
        );
        await Future.delayed(Duration(seconds: 2));
        Get.offAll(() => const LoginScreen());
        return;
      }

      // Check if user is logged in
      final isLoggedIn = await AuthService.isLoggedIn();
      final token = await AuthService.getToken();

      if (isLoggedIn && token != null) {
        // User is logged in, navigate to home screen
        Get.offAll(() => BottomNavScreen(token: token));
      } else {
        // User is not logged in, navigate to login screen
        Get.offAll(() => const LoginScreen());
      }
    } catch (e) {
      print('Error in _checkAuthAndNavigate: $e');
      // In case of error, default to login screen
      Get.offAll(() => const LoginScreen());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset('assets/images/splash.png', fit: BoxFit.cover),
          ),
          Positioned(
            top: 20.h,
            right: 20.w,
            child: SlideTransition(
              position: _satelliteSlideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Image.asset(
                  'assets/images/satalight.png',
                  width: 150,
                  height: 150,
                ),
              ),
            ),
          ),
          Center(
            child: SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Image.asset(
                  'assets/images/SkySeek.png',
                  width: 180.w,
                  height: 180.h,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
