import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sky_seek/screens/SplashScreen/splashscreen.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    try {
      await SharedPreferences.getInstance();
      debugPrint('SharedPreferences initialized successfully');
    } catch (e) {
      debugPrint('SharedPreferences initialization error:$e');
    }

    runApp(const MyApp());
  } catch (e, stackTrace) {
    debugPrint('Fatal error in main: $e');
    debugPrint('Stack trace: $stackTrace');
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(child: Text('App initialization error: $e')),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
        );
      },
    );
  }
}
