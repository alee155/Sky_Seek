// lib/widgets/multi_line_tile.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MultiLineTile extends StatelessWidget {
  final IconData icon;
  final String content;

  const MultiLineTile({super.key, required this.icon, required this.content});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.yellowAccent, size: 22.sp),
      title: Text(
        content,
        style: TextStyle(color: Colors.white, fontSize: 14.5.sp),
      ),
    );
  }
}
