import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:opticscan/app/shared/bindings/initial_binding.dart';
import 'package:opticscan/utils/theme/theme.dart';

import 'app/routes/app_pages.dart';
import 'package:opticscan/eye_scanner/eye_scanner_screen.dart';
import 'package:opticscan/form_submit/Eye_Scanner_Result.dart';
import 'package:opticscan/homepage/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "OpticScan",
      initialRoute: AppPages.INITIAL,
      initialBinding: InitialBinding(),
      getPages: AppPages.routes,
      theme: OAppTheme.themeApp,
    ),
  );
}
