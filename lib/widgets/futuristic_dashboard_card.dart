import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FuturisticDashboardCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  final Color primaryColor;
  final Color secondaryColor;
  final Color highlightColor;
  final double width;
  final double height;

  const FuturisticDashboardCard({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
    this.primaryColor = const Color(0xFF1A2038),
    this.secondaryColor = const Color(0xFF303854),
    this.highlightColor = Colors.tealAccent,
    this.width = 172,
    this.height = 85,
  });

  @override
  State<FuturisticDashboardCard> createState() =>
      _FuturisticDashboardCardState();
}

class _FuturisticDashboardCardState extends State<FuturisticDashboardCard>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: widget.height.h,
        width: widget.width.w,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [widget.primaryColor, widget.secondaryColor],
          ),
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.r),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Container(
                      // Much wider shine effect
                      width: constraints.maxWidth * 0.8,
                    );
                  },
                ),
              ),
            ),

            // Content
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SpaceGrotesk',
                            letterSpacing: 0.5,
                            shadows: [
                              Shadow(
                                color: widget.highlightColor.withOpacity(0.5),
                                blurRadius: 5,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: widget.highlightColor.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      widget.icon,
                      color: widget.highlightColor,
                      size: 22.sp,
                    ),
                  ),
                ],
              ),
            ),

            // Angular corner accent
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: 20.w,
                height: 20.h,
                decoration: BoxDecoration(
                  color: widget.highlightColor.withOpacity(0.6),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.r),
                    bottomRight: Radius.circular(6.r),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
