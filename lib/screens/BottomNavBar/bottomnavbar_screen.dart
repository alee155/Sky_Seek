import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sky_seek/screens/BottomNavBar/fav_screen.dart';
import 'package:sky_seek/screens/BottomNavBar/home_screen.dart';
import 'package:sky_seek/screens/BottomNavBar/profile_screen.dart';
import 'package:sky_seek/screens/SettingsScreen/settings_screen.dart';

class BottomNavScreen extends StatefulWidget {
  final String token;

  const BottomNavScreen({super.key, required this.token});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _selectedIndex = 0;
  late final List<Widget> _screens;

  final List<Map<String, dynamic>> _navItems = [
    {
      'icon': Icons.public,
      'label': 'Home',
      'gradient': [Color(0xFF3B82F6), Color(0xFF1E3A8A)],
    },
    {
      'icon': Icons.favorite,
      'label': 'Favorites',
      'gradient': [Color(0xFFEC4899), Color(0xFF9D174D)],
    },
    {
      'icon': Icons.settings,
      'label': 'Settings',
      'gradient': [Color(0xFF10B981), Color(0xFF065F46)],
    },
    {
      'icon': Icons.person,
      'label': 'Profile',
      'gradient': [Color(0xFF8B5CF6), Color(0xFF5B21B6)],
    },
  ];

  @override
  void initState() {
    super.initState();

    _screens = [
      HomeScreen(token: widget.token),
      MyFavoritScreen(token: widget.token),
      const SettingsScreen(),
      ProfileScreen(token: widget.token),
    ];
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _screens[_selectedIndex],
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          color: Colors.black,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              _navItems.length,
              (index) => _buildNavItem(index),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final bool isSelected = _selectedIndex == index;
    final item = _navItems[index];

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 44.w,
        height: 44.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient:
              isSelected
                  ? LinearGradient(
                    colors: item['gradient'],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                  : null,
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: item['gradient'][0].withOpacity(0.6),
                      blurRadius: 12,
                      spreadRadius: 1,
                    ),
                  ]
                  : null,
        ),
        child: Icon(
          item['icon'],
          size: 22.w,
          color: isSelected ? Colors.white : Colors.grey,
        ),
      ),
    );
  }
}
