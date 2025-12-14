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
  _BottomNavScreenState createState() => _BottomNavScreenState();
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

    print(
      "*************User Token In BottomNavBar*************: ${widget.token}",
    );

    _screens = [
      HomeScreen(token: widget.token),
      MyFavoritScreen(token: widget.token),
      SettingsScreen(),
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
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        height: 80.h,
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(_navItems.length, (index) {
            return _buildNavItem(index);
          }),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final isSelected = _selectedIndex == index;
    final item = _navItems[index];

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        width: 40.w,
        height: 40.w,
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
          color: isSelected ? null : Colors.transparent,
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: item['gradient'][0].withOpacity(0.7),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ]
                  : null,
        ),
        child: Icon(
          item['icon'],
          color: isSelected ? Colors.white : Colors.grey,
          size: 20.w,
        ),
      ),
    );
  }
}
