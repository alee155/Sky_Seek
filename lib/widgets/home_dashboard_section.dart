import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:sky_seek/screens/Animations/animations_menu_screen.dart';
import 'package:sky_seek/screens/Compare/compare_planets_screen.dart';
import 'package:sky_seek/screens/GalaxyDetails/galaxies_list_screen.dart';
import 'package:sky_seek/screens/PlanetDetails/scroll_planets_screen.dart';
import 'package:sky_seek/screens/QuizScreen/quiz_results_list_screen.dart';
import 'package:sky_seek/screens/QuizScreen/quiz_type_screen.dart';
import 'package:sky_seek/screens/Satellite/satellite_screen.dart';
import 'package:sky_seek/screens/StarDetails/stars_list_screen.dart';
import 'package:sky_seek/widgets/futuristic_dashboard_card.dart';

class HomeDashboardSection extends StatelessWidget {
  final String? token;

  const HomeDashboardSection({super.key, this.token});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _row(
          left: FuturisticDashboardCard(
                title: "Discover Planets",
                icon: Icons.public,
                primaryColor: const Color(0xFF0A4DA2),
                secondaryColor: const Color(0xFF0F2B61),
                highlightColor: const Color(0xFF4FC3F7),
                onTap: () {
                  Get.to(
                    () => const ScrollPlanetsScreen(),
                    transition: Transition.fadeIn,
                    duration: const Duration(milliseconds: 200),
                  );
                },
              )
              .animate()
              .fade(duration: 500.ms)
              .slideX(begin: -1.0, duration: 300.ms, curve: Curves.easeInOut),
          right: FuturisticDashboardCard(
                title: "Play Quiz",
                icon: Icons.quiz,
                primaryColor: const Color(0xFF6A1B9A),
                secondaryColor: const Color(0xFF4A148C),
                highlightColor: const Color(0xFFAB47BC),
                onTap: () {
                  Get.to(
                    () => const QuizTypeScreen(),
                    transition: Transition.fadeIn,
                    duration: const Duration(milliseconds: 200),
                  );
                },
              )
              .animate()
              .fade(duration: 500.ms)
              .slideX(begin: 1.0, duration: 300.ms, curve: Curves.easeInOut),
        ),
        5.h.verticalSpace,

        _row(
          left: FuturisticDashboardCard(
                title: "View Animation",
                icon: Icons.play_circle_outline,
                primaryColor: const Color(0xFF00695C),
                secondaryColor: const Color(0xFF004D40),
                highlightColor: const Color(0xFF1DE9B6),
                onTap: () {
                  Get.to(
                    () => const AnimationsMenuScreen(),
                    transition: Transition.fadeIn,
                    duration: const Duration(milliseconds: 200),
                  );
                },
              )
              .animate()
              .fade(duration: 500.ms)
              .slideX(begin: -1.0, duration: 300.ms, curve: Curves.easeInOut),
          right: FuturisticDashboardCard(
                title: "Compare Planets",
                icon: Icons.compare_arrows,
                primaryColor: const Color(0xFF880E4F),
                secondaryColor: const Color(0xFF560027),
                highlightColor: const Color(0xFFFF80AB),
                onTap: () {
                  Get.to(
                    () => const ComparePlanetsScreen(),
                    transition: Transition.fadeIn,
                    duration: const Duration(milliseconds: 200),
                  );
                },
              )
              .animate()
              .fade(duration: 500.ms)
              .slideX(begin: 1.0, duration: 300.ms, curve: Curves.easeInOut),
        ),
        5.h.verticalSpace,

        _row(
          left: FuturisticDashboardCard(
                title: "Quiz Results",
                icon: Icons.star_rate,
                primaryColor: const Color(0xFFF57F17),
                secondaryColor: const Color(0xFFC43E00),
                highlightColor: const Color(0xFFFFD740),
                onTap: () {
                  Get.to(
                    () => QuizResultsListScreen(),
                    transition: Transition.fadeIn,
                    duration: const Duration(milliseconds: 200),
                  );
                },
              )
              .animate()
              .fade(duration: 500.ms)
              .slideX(begin: -1.0, duration: 300.ms, curve: Curves.easeInOut),
          right: FuturisticDashboardCard(
                title: "Discover Galaxies",
                icon: Icons.auto_awesome,
                primaryColor: const Color(0xFF006064),
                secondaryColor: const Color(0xFF002930),
                highlightColor: const Color(0xFF00E5FF),
                onTap: () {
                  Get.to(
                    () => GalaxiesListScreen(token: token),
                    transition: Transition.fadeIn,
                    duration: const Duration(milliseconds: 200),
                  );
                },
              )
              .animate()
              .fade(duration: 500.ms)
              .slideX(begin: 1.0, duration: 300.ms, curve: Curves.easeInOut),
        ),
        5.h.verticalSpace,

        _row(
          left: FuturisticDashboardCard(
                title: "Discover Satellite",
                icon: Icons.satellite_alt,
                primaryColor: const Color(0xFFD32F2F),
                secondaryColor: const Color(0xFF121212),
                highlightColor: const Color(0xFFFF5252),
                onTap: () {
                  Get.to(
                    () => SatelliteScreen(),
                    transition: Transition.fadeIn,
                    duration: const Duration(milliseconds: 200),
                  );
                },
              )
              .animate()
              .fade(duration: 500.ms)
              .slideX(begin: -1.0, duration: 300.ms, curve: Curves.easeInOut),
          right: FuturisticDashboardCard(
                title: "Discover Stars",
                icon: Icons.auto_awesome,
                primaryColor: const Color(0xFFC79100),
                secondaryColor: const Color(0xFF7F4F00),
                highlightColor: const Color(0xFFFFEA00),
                onTap: () {
                  Get.to(
                    () => StarsListScreen(token: token),
                    transition: Transition.fadeIn,
                    duration: const Duration(milliseconds: 200),
                  );
                },
              )
              .animate()
              .fade(duration: 500.ms)
              .slideX(begin: 1.0, duration: 300.ms, curve: Curves.easeInOut),
        ),
      ],
    );
  }

  Widget _row({required Widget left, required Widget right}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [left, right],
    );
  }
}
