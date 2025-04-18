import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opticscan/app/routes/app_pages.dart';
import 'package:opticscan/app/shared/bindings/main_binding.dart';
import 'package:opticscan/app/shared/widgets/main_layout.dart';

class NavBarItem {
  final IconData icon;
  final String route;
  final String label;

  NavBarItem({
    required this.icon,
    required this.route,
    required this.label,
  });
}

class PersistentBottomNavBar extends StatelessWidget {
  final int currentIndex;

  // RUTE UNTUK BOTTOM NAVBAR
  static final List<NavBarItem> items = [
    NavBarItem(
      icon: Icons.home_outlined,
      route: Routes.HOME,
      label: 'Home',
    ),
    NavBarItem(
      icon: Icons.article_outlined,
      route: Routes.RIWAYAT,
      label: 'Riwayat',
    ),
    NavBarItem(
      icon: Icons.person_outline,
      route: Routes.PROFILE,
      label: 'Profile',
    ),
  ];

  const PersistentBottomNavBar({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, -2),
          ),
        ],
      ),
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isSelected = index == currentIndex;

          return _buildNavItem(
            icon: item.icon,
            isSelected: isSelected,
            route: item.route,
            label: item.label,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required bool isSelected,
    required String route,
    required String label,
  }) {
    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          Get.offAll(
            () => MainLayout(currentRoute: route),
            binding: MainBinding(),
            transition: Transition.noTransition,
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? const Color(0xFF146EF5) : Colors.grey,
            size: 28,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? const Color(0xFF146EF5) : Colors.grey,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 4,
            width: 4,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? const Color(0xFF146EF5) : Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}
