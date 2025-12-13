import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sky_seek/controller/profile_controller.dart';
import 'package:sky_seek/widgets/star_background.dart';
import 'package:sky_seek/services/auth_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen>
    with SingleTickerProviderStateMixin {
  final ProfileController profileController = Get.find<ProfileController>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  String selectedGender = 'Male';
  bool isLoading = false;

  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeProfileData();
    _setupAnimations();
  }

  void _initializeProfileData() {
    if (profileController.profile.value != null) {
      final profile = profileController.profile.value!;
      firstNameController.text = profile.firstName;
      lastNameController.text = profile.lastName;

      String gender = profile.gender;
      if (gender.isNotEmpty) {
        gender = gender[0].toUpperCase() + gender.substring(1).toLowerCase();
        if (gender == 'Male' || gender == 'Female') {
          selectedGender = gender;
        }
      }
    }
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeInAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    Future.delayed(const Duration(milliseconds: 200), () {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    if (firstNameController.text.trim().isEmpty ||
        lastNameController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter both first and last name',
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final token = await AuthService.getToken();

      if (token == null || token.isEmpty) {
        throw Exception('Authentication token not available');
      }

      debugPrint('Using token for profile update: $token');

      final success = await profileController.updateProfile(
        token: token,
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        gender: selectedGender,
      );

      if (success) {
        await profileController.refreshProfile(token);
        if (Get.isSnackbarOpen) {
          Get.closeAllSnackbars();
        }
        Navigator.of(context).pop();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile: ${e.toString()}',
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildFormField(String label, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.white, fontSize: 16.sp),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white70, fontSize: 14.sp),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: Colors.tealAccent.withOpacity(0.5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(color: Colors.tealAccent, width: 2),
          ),
          filled: true,
          fillColor: Colors.black.withOpacity(0.3),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 16.h,
          ),
        ),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.tealAccent.withOpacity(0.5)),

          color: Colors.black.withOpacity(0.3),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedGender,
            dropdownColor: Colors.black87,
            isExpanded: true,
            icon: const Icon(Icons.arrow_drop_down, color: Colors.tealAccent),
            style: TextStyle(color: Colors.white, fontSize: 16.sp),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  selectedGender = newValue;
                });
              }
            },
            items:
                <String>['Male', 'Female'].map<DropdownMenuItem<String>>((
                  String value,
                ) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value.substring(0, 1).toUpperCase() + value.substring(1),
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SizedBox.expand(
            child: Image.asset(
              'assets/images/profile.png',
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.5),
              colorBlendMode: BlendMode.darken,
            ),
          ),

          StarBackground(starCount: 150, opacity: 0.8),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeInAnimation,
                    child: Transform.translate(
                      offset: Offset(0, _slideAnimation.value),
                      child: child,
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    Text(
                      'Update Your Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.tealAccent.withOpacity(0.5),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Customize your personal information below',
                      style: TextStyle(
                        color: Colors.grey[300],
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 30.h),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(16.r),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: EdgeInsets.all(20.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFormField(
                                'Enter your first name',
                                firstNameController,
                              ),
                              SizedBox(height: 8.h),
                              _buildFormField(
                                'Enter your last name',
                                lastNameController,
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                'Select Gender',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14.sp,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              _buildGenderDropdown(),
                              SizedBox(height: 24.h),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: isLoading ? null : _updateProfile,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.tealAccent,
                                    foregroundColor: Colors.black,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 15.h,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    elevation: 8,
                                  ),
                                  child:
                                      isLoading
                                          ? CircularProgressIndicator(
                                            color: Colors.black,
                                          )
                                          : Text(
                                            'Save Changes',
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
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
            ),
          ),

          Positioned(
            top: -50,
            right: -100,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.tealAccent.withOpacity(0.2),
                    blurRadius: 100,
                    spreadRadius: 50,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
