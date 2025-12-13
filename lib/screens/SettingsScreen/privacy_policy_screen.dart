import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

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
          'Privacy Policy',
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
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('Sky Seek Privacy Policy'),

                    _buildSectionTitle('1. Introduction'),
                    _buildParagraph(
                      'Welcome to Sky Seek ("we," "our," or "us"). This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application ("Sky Seek" or "App").',
                    ),
                    _buildParagraph(
                      'Please read this privacy policy carefully. If you do not agree with the terms of this privacy policy, please do not access the application.',
                    ),

                    _buildSectionTitle('2. Information We Collect'),
                    _buildSubSectionTitle('2.1 Information You Provide to Us:'),
                    _buildBulletPoint(
                      'Account Information: When you register for an account, we collect your first name, last name, email address, gender, and authentication information.',
                    ),
                    _buildBulletPoint(
                      'Quiz Results: When you participate in quizzes, we collect and store your quiz performance data.',
                    ),
                    _buildBulletPoint(
                      'User Preferences: Information about your favorite planets and celestial objects.',
                    ),

                    _buildSubSectionTitle(
                      '2.2 Information Automatically Collected:',
                    ),
                    _buildBulletPoint(
                      'Device Information: We collect device-specific information such as operating system version and device type.',
                    ),
                    _buildBulletPoint(
                      'Log and Usage Data: Information related to your use of the App, including timestamps and interactions with app features.',
                    ),

                    _buildSectionTitle('3. How We Use Your Information'),
                    _buildParagraph(
                      'We may use the information we collect for various purposes, including:',
                    ),
                    _buildBulletPoint('To provide and maintain our App'),
                    _buildBulletPoint('To create and update your user profile'),
                    _buildBulletPoint(
                      'To save your favorite celestial objects',
                    ),
                    _buildBulletPoint(
                      'To track your quiz performance and results',
                    ),
                    _buildBulletPoint('To improve our App and user experience'),
                    _buildBulletPoint(
                      'To respond to your inquiries and customer service requests',
                    ),

                    _buildSectionTitle('4. Sharing of Your Information'),
                    _buildParagraph(
                      'We do not share, sell, rent, or trade your personal information with third parties except in the following circumstances:',
                    ),
                    _buildBulletPoint('With your consent'),
                    _buildBulletPoint('To comply with legal obligations'),
                    _buildBulletPoint(
                      'To protect and defend our rights and property',
                    ),
                    _buildBulletPoint(
                      'With service providers who work on our behalf and have agreed to maintain confidentiality',
                    ),

                    _buildSectionTitle('5. Data Storage and Security'),
                    _buildParagraph(
                      'We use commercially reasonable security measures to protect your personal information. However, no method of transmission over the Internet or electronic storage is 100% secure, and we cannot guarantee absolute security.',
                    ),

                    _buildSectionTitle('6. Your Rights'),
                    _buildParagraph(
                      'Depending on your location, you may have rights concerning your personal data, including:',
                    ),
                    _buildBulletPoint(
                      'The right to access personal data we hold about you',
                    ),
                    _buildBulletPoint(
                      'The right to request correction of inaccurate data',
                    ),
                    _buildBulletPoint(
                      'The right to request deletion of your data',
                    ),
                    _buildBulletPoint('The right to withdraw consent'),

                    _buildSectionTitle('7. Children\'s Privacy'),
                    _buildParagraph(
                      'Our app is valid for any kind of age users.',
                    ),

                    _buildSectionTitle('8. Changes to This Privacy Policy'),
                    _buildParagraph(
                      'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the "Effective Date" at the top.',
                    ),

                    _buildSectionTitle('9. Third-Party Services'),
                    _buildParagraph(
                      'Our app uses the following third-party services:',
                    ),
                    _buildBulletPoint('HTTP package for API communication'),
                    _buildBulletPoint(
                      'Shared Preferences for local data storage',
                    ),
                    _buildBulletPoint(
                      'URL Launcher for external link handling',
                    ),

                    _buildSectionTitle('10. Permissions'),
                    _buildParagraph(
                      'Sky Seek requires the following permissions:',
                    ),
                    _buildBulletPoint(
                      'Internet Access: Required to download celestial data, images, and communicate with our servers.',
                    ),

                    _buildSectionTitle('11. Contact Us'),
                    _buildParagraph(
                      'If you have any questions about this Privacy Policy, please contact us at:',
                    ),
                    _buildBulletPoint('Email: devsouqtechnologies@gmail.com'),
                    _buildBulletPoint('Website: https://devsouq.com/'),

                    _buildSectionTitle('12. Data Retention'),
                    _buildParagraph(
                      'We will retain your personal information only for as long as is necessary for the purposes set out in this Privacy Policy.',
                    ),

                    _buildSectionTitle('13. International Data Transfers'),
                    _buildParagraph(
                      'Your information may be transferred to and maintained on computers located outside of your state, province, country, or other governmental jurisdiction where the data protection laws may differ.',
                    ),

                    _buildSectionTitle('14. Consent'),
                    _buildParagraph(
                      'By using our app, you consent to our Privacy Policy and agree to its terms.',
                    ),

                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.tealAccent,
          fontSize: 24.sp,
          fontFamily: 'SpaceGrotesk',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Padding(
      padding: EdgeInsets.only(top: 20.h, bottom: 10.h),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.sp,
          fontFamily: 'SpaceGrotesk',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSubSectionTitle(String text) {
    return Padding(
      padding: EdgeInsets.only(top: 16.h, bottom: 8.h),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18.sp,
          fontFamily: 'SpaceGrotesk',
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSubtitle(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white70,
          fontSize: 16.sp,
          fontFamily: 'Poppins',
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white.withOpacity(0.9),
          fontSize: 16.sp,
          fontFamily: 'Poppins',
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: EdgeInsets.only(left: 16.w, bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "•  ",
            style: TextStyle(
              color: Colors.tealAccent,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 16.sp,
                fontFamily: 'Poppins',
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
