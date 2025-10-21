import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnimatedInfoTile extends StatefulWidget {
  final IconData icon;
  final String title;
  final String value;
  final int index;
  final AnimationController animationController;
  final Color iconColor;
  final Color iconBackgroundColor;

  const AnimatedInfoTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
    required this.index,
    required this.animationController,
    this.iconColor = Colors.tealAccent,
    this.iconBackgroundColor = Colors.black12,
  }) : super(key: key);

  @override
  State<AnimatedInfoTile> createState() => _AnimatedInfoTileState();
}

class _AnimatedInfoTileState extends State<AnimatedInfoTile> {
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Calculate the delay based on item index
    final startInterval = widget.index * 0.05;
    final endInterval = startInterval + 0.2;

    // Create fade in animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: Interval(
          startInterval.clamp(0.0, 0.9),
          endInterval.clamp(0.1, 1.0),
          curve: Curves.easeOut,
        ),
      ),
    );

    // Create slide animation from bottom
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: Interval(
          startInterval.clamp(0.0, 0.9),
          endInterval.clamp(0.1, 1.0),
          curve: Curves.easeOutCubic,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(position: _slideAnimation, child: child),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.white10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: widget.iconBackgroundColor,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(widget.icon, color: widget.iconColor, size: 18.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12.sp,
                      fontFamily: 'SpaceGrotesk',
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    widget.value,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
