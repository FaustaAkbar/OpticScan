import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opticscan/features/home/views/home_view.dart';
import 'package:opticscan/services/user_service.dart';
import 'package:opticscan/utils/theme/theme.dart';
import 'package:opticscan/views/splash_view.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: OAppTheme.themeApp,
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final UserService _userService = Get.find<UserService>();

  @override
  void initState() {
    super.initState();
    _navigateBasedOnAuth();
  }

  Future<void> _navigateBasedOnAuth() async {
    await Future.delayed(const Duration(milliseconds: 800));

    if (_userService.isLoggedIn.value) {
      Get.offAll(() => const HomeView());
    } else {
      Get.offAll(() => const SplashView());
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
