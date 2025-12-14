import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnimatedInfoTile extends StatefulWidget {
  final IconData icon;
  final String title;
  final String value;
  final int index;

  final Color iconColor;
  final Color iconBackgroundColor;

  const AnimatedInfoTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
    required this.index,

    this.iconColor = Colors.tealAccent,
    this.iconBackgroundColor = Colors.black12,
  }) : super(key: key);

  @override
  State<AnimatedInfoTile> createState() => _AnimatedInfoTileState();
}

class _AnimatedInfoTileState extends State<AnimatedInfoTile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
