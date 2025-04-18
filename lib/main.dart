import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:opticscan/utils/theme/theme.dart';

import 'app/routes/app_pages.dart';

void main() {
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "OpticScan",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: OAppTheme.themeApp,
    ),
  );
}
