import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Terms & Conditions',
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
          // Background Image
          Image.asset(
            'assets/images/infobg.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // Gradient Overlay
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
          // Scrollable Content
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('Sky Seek Terms and Conditions'),

                  _buildSectionTitle('1. Acceptance of Terms'),
                  _buildParagraph(
                    'By accessing or using the Sky Seek application ("App"), you agree to be bound by these Terms and Conditions. If you disagree with any part of these terms, you may not access or use the App.',
                  ),

                  _buildSectionTitle('2. User Accounts'),
                  _buildBulletPoint(
                    'Users must provide accurate and complete information when creating an account.',
                  ),
                  _buildBulletPoint(
                    'Users are responsible for maintaining the confidentiality of their account credentials.',
                  ),
                  _buildBulletPoint(
                    'Users are responsible for all activities that occur under their account.',
                  ),
                  _buildBulletPoint(
                    'Users must notify us immediately of any unauthorized use of their account.',
                  ),

                  _buildSectionTitle('3. User Data and Privacy'),
                  _buildBulletPoint(
                    'We collect and process personal information as described in our Privacy Policy.',
                  ),
                  _buildBulletPoint(
                    'By using the App, you consent to data collection practices outlined in the Privacy Policy.',
                  ),
                  _buildBulletPoint(
                    'We implement reasonable security measures to protect your personal information.',
                  ),

                  _buildSectionTitle('4. Content and Usage Restrictions'),
                  _buildBulletPoint(
                    'The App provides educational and informational content about celestial objects and astronomy.',
                  ),
                  _buildBulletPoint(
                    'Users may not use the App for any illegal purpose or in violation of any local laws.',
                  ),
                  _buildBulletPoint(
                    'Users may not attempt to gain unauthorized access to any portion of the App.',
                  ),
                  _buildBulletPoint(
                    'We reserve the right to suspend or terminate accounts that violate these restrictions.',
                  ),

                  _buildSectionTitle('5. Intellectual Property'),
                  _buildParagraph(
                    'All content provided through the App, including text, graphics, images, and information about celestial objects, is the property of Sky Seek or its content providers. Users may not reproduce, distribute, modify, or create derivative works from any content without express permission.',
                  ),

                  _buildSectionTitle('6. Disclaimers and Limitations'),
                  _buildParagraph(
                    'The App is provided on an "as is" and "as available" basis. We do not warrant that the App will be uninterrupted, error-free, or completely accurate. Information about space objects is provided for educational purposes and may be updated as scientific knowledge evolves.',
                  ),

                  _buildSectionTitle('7. Updates to Terms'),
                  _buildParagraph(
                    'We reserve the right to modify these Terms at any time. Continued use of the App after changes constitutes acceptance of the modified Terms. Significant changes will be notified to users via the App or email.',
                  ),

                  _buildSectionTitle('8. Termination'),
                  _buildParagraph(
                    'We reserve the right to suspend or terminate user access to the App for violations of these Terms. Users may terminate their account at any time by following the instructions in the App.',
                  ),

                  _buildSectionTitle('9. Governing Law'),
                  _buildParagraph(
                    'These Terms shall be governed by and construed in accordance with applicable laws. Any disputes arising under these Terms shall be subject to the exclusive jurisdiction of the courts in your jurisdiction.',
                  ),

                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper Widgets (same style as your PrivacyPolicyScreen)
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
