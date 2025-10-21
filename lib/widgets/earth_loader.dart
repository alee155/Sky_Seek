import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EarthLoader extends StatelessWidget {
  final double size;

  const EarthLoader({super.key, this.size = 120});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: size.w,
        height: size.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const RadialGradient(
            colors: [Colors.lightBlue, Colors.blue, Colors.indigo],
            stops: [0.3, 0.6, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: ClipOval(
          child: Image.asset(
            'assets/images/earthloader.gif',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
