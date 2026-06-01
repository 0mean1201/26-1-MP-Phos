import 'package:flutter/material.dart';
import 'dart:ui';
import 'home_screen.dart';
import 'gallery_screen.dart';
import 'studio_screen.dart';
import '../core/constants.dart';
import '../core/app_state.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});
  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeScreen(onViewAll: () => setState(() => _currentIndex = 1)),
      const GalleryScreen(),
      const StudioScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navBg = isDark ? AppColors.darkNavBar : Colors.white;
    final selectedColor = isDark ? AppColors.darkPrimary : AppColors.primary;
    final unselectedColor = isDark ? AppColors.darkTextSub : Colors.grey;

    return Scaffold(
      extendBody: true,
      body: _pages[_currentIndex],
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            color: navBg.withOpacity(isDark ? 0.85 : 0.7),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) => setState(() => _currentIndex = index),
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedItemColor: selectedColor,
              unselectedItemColor: unselectedColor,
              items: [
                BottomNavigationBarItem(
                  icon: _buildNavIcon(Icons.camera_alt, 0, selectedColor),
                  label: 'START',
                ),
                BottomNavigationBarItem(
                  icon: _buildNavIcon(Icons.photo_library, 1, selectedColor),
                  label: 'GALLERY',
                ),
                BottomNavigationBarItem(
                  icon: _buildNavIcon(Icons.brush, 2, selectedColor),
                  label: 'STUDIO',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, int index, Color selectedColor) {
    final isSelected = _currentIndex == index;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isSelected ? selectedColor : Colors.transparent,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: isSelected ? Colors.white : Colors.grey,
      ),
    );
  }
}