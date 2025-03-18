import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opticscan/features/authentication/screens/login/login.dart';
import 'package:opticscan/services/user_service.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final UserService _userService = Get.find<UserService>();

  Future<void> _logout() async {
    await _userService.logout();
    Get.offAll(() => const LoginView());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HOme"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _logout,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Logout',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
