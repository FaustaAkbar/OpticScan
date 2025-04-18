import 'package:flutter/material.dart';
import 'package:opticscan/app/modules/home/views/home_view.dart';
import 'package:opticscan/app/modules/profile/views/profile_view.dart';
import 'package:opticscan/app/modules/riwayat/views/riwayat_view.dart';
import 'package:opticscan/app/routes/app_pages.dart';
import 'package:opticscan/app/shared/widgets/persistent_bottom_nav_bar.dart';

class MainLayout extends StatelessWidget {
  final String currentRoute;

  const MainLayout({
    Key? key,
    required this.currentRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBody() {
    // UNTUK MENAMPILKAN HALAMAN BERDASARKAN RUTE
    switch (currentRoute) {
      case Routes.HOME:
        return const HomeView();
      case Routes.RIWAYAT:
        return const RiwayatView();
      case Routes.PROFILE:
        return const ProfileView();
      default:
        return const HomeView();
    }
  }

  Widget _buildBottomNavBar() {
    // MENENTUKAN INDEX BERDASARKAN RUTE
    int currentIndex;

    switch (currentRoute) {
      case Routes.HOME:
        currentIndex = 0;
        break;
      case Routes.RIWAYAT:
        currentIndex = 1;
        break;
      case Routes.PROFILE:
        currentIndex = 2;
        break;
      default:
        currentIndex = 0;
    }

    return PersistentBottomNavBar(currentIndex: currentIndex);
  }
}
