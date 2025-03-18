import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opticscan/app.dart';
import 'package:opticscan/services/user_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize user service
  Get.put(UserService());

  runApp(const App());
}
