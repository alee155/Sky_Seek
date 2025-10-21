import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'About Us',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.sp,
            fontFamily: 'SpaceGrotesk',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background with stars
          Image.asset(
            'assets/images/infobg.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // Gradient overlay
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
          // Content
          SafeArea(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 120.w,
                      height: 120.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.3),
                        border: Border.all(
                          color: Colors.tealAccent.withOpacity(0.5),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/appicon.png',
                            width: 100.w,
                            height: 100.w,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'Sky Seek',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        fontFamily: 'SpaceGrotesk',
                      ),
                    ),
                    Text(
                      'Explore the Universe',
                      style: TextStyle(
                        color: Colors.tealAccent,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                      ),
                    ),

                    SizedBox(height: 10.h),

                    // Mission Statement
                    _buildInfoSection(
                      title: 'Our Mission',
                      content:
                          'Our mission is to make space exploration accessible to everyone.',
                      icon: Icons.rocket_launch,
                    ),

                    SizedBox(height: 10.h),

                    // Brief Description
                    _buildInfoSection(
                      title: 'About the App',
                      content:
                          'Sky Seek brings the wonders of the cosmos to your fingertips. Discover planets, galaxies, satellites, and explore deep space data with stunning visuals.',
                      icon: Icons.info_outline,
                    ),

                    SizedBox(height: 10.h),
                    _buildInfoSection(
                      title: 'Contact Us',
                      contentWidget: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final Uri emailLaunchUri = Uri(
                                scheme: 'mailto',
                                path: 'devsouqtechnologies@gmail.com',
                              );
                              await launchUrl(emailLaunchUri);
                            },
                            child: Text(
                              'Email: devsouqtechnologies@gmail.com',
                              style: TextStyle(
                                color: Colors.tealAccent,
                                fontSize: 16.sp,
                                fontFamily: 'Poppins',
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          SizedBox(height: 6.h),
                          GestureDetector(
                            onTap: () async {
                              final Uri url = Uri.parse('https://devsouq.com/');
                              if (!await launchUrl(
                                url,
                                mode: LaunchMode.externalApplication,
                              )) {
                                throw 'Could not launch $url';
                              }
                            },
                            child: Text(
                              'Website: https://devsouq.com/',
                              style: TextStyle(
                                color: Colors.tealAccent,
                                fontSize: 16.sp,
                                fontFamily: 'Poppins',
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                      icon: Icons.email,
                    ),

                    SizedBox(height: 10.h),

                    Text(
                      '© 2025 Sky Seek. All rights reserved.',
                      style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection({
    required String title,
    String? content,
    Widget? contentWidget,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.tealAccent, size: 22.sp),
              SizedBox(width: 10.w),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontFamily: 'SpaceGrotesk',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          contentWidget ??
              Text(
                content ?? '',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 16.sp,
                  fontFamily: 'Poppins',
                  height: 1.5,
                ),
              ),
        ],
      ),
    );
  }
}
