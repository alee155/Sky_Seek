// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:sky_seek/controller/planet_controller.dart';

// class PlanetDetailsScreen extends StatefulWidget {
//   const PlanetDetailsScreen({super.key});

//   @override
//   State<PlanetDetailsScreen> createState() => _PlanetDetailsScreenState();
// }

// class _PlanetDetailsScreenState extends State<PlanetDetailsScreen> {
//   final PlanetController controller = Get.put(PlanetController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Stack(
//         children: [
//           // Background Image
//           SizedBox.expand(
//             child: Image.asset('assets/images/infobg.png', fit: BoxFit.cover),
//           ),

//           // Title
//           Positioned(
//             top: 70.h,
//             left: 20.w,
//             child: Text(
//               "Planets Details",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 20.sp,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),

//           // Planets List
//           Positioned.fill(
//             top: 120.h,
//             child: Obx(() {
//               if (controller.isLoading.value) {
//                 return const Center(
//                   child: CircularProgressIndicator(color: Colors.white),
//                 );
//               }

//               if (controller.planets.isEmpty) {
//                 return const Center(
//                   child: Text(
//                     "No planets found",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 );
//               }

//               return ListView.builder(
//                 padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
//                 itemCount: controller.planets.length,
//                 itemBuilder: (context, index) {
//                   final planet = controller.planets[index];
//                   return Container(
//                     margin: EdgeInsets.only(bottom: 12.h),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(12.r),
//                       border: Border.all(color: Colors.white24),
//                     ),
//                     child: ListTile(
//                       contentPadding: EdgeInsets.all(12.w),
//                       leading: CircleAvatar(
//                         radius: 28.r,
//                         backgroundImage:
//                             planet.image.isNotEmpty
//                                 ? NetworkImage(planet.image)
//                                 : const AssetImage('assets/images/female.png')
//                                     as ImageProvider,
//                         backgroundColor: Colors.transparent,
//                       ),
//                       title: Text(
//                         planet.name,
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 18.sp,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Type: ${planet.type}",
//                             style: TextStyle(
//                               color: Colors.white70,
//                               fontSize: 12.sp,
//                             ),
//                           ),
//                           Text(
//                             "Position: ${planet.position}",
//                             style: TextStyle(
//                               color: Colors.white70,
//                               fontSize: 12.sp,
//                             ),
//                           ),
//                           Text(
//                             "Gravity: ${planet.gravity}",
//                             style: TextStyle(
//                               color: Colors.white70,
//                               fontSize: 12.sp,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }
// }
