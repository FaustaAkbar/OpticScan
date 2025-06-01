import 'package:flutter/material.dart';
import 'package:IntelliSight/app/modules/home/views/home_view.dart';
import 'package:IntelliSight/app/modules/profile/views/profile_view.dart';
import 'package:IntelliSight/app/modules/riwayat/views/riwayat_view.dart';
import 'package:IntelliSight/app/routes/app_pages.dart';
import 'package:IntelliSight/app/shared/widgets/persistent_bottom_nav_bar.dart';

class MainLayout extends StatelessWidget {
  final String currentRoute;

  const MainLayout({
    super.key,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBody() {
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
