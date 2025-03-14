import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class CustomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomNavBar(
      {super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      onTap: onTap,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
        BottomNavigationBarItem(
            icon: Icon(LucideIcons.clipboardList), label: ""),
        BottomNavigationBarItem(icon: Icon(LucideIcons.user), label: ""),
      ],
    );
  }
}
