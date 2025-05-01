import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:IntelliSight/app/shared/bindings/initial_binding.dart';
import 'package:IntelliSight/utils/theme/theme.dart';

import 'app/routes/app_pages.dart';

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
