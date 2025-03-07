import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opticscan/features/authentication/screens/login/login.dart';
import 'package:opticscan/utils/theme/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: OAppTheme.themeApp,
      home: const LoginView(),
    );
  }
}
