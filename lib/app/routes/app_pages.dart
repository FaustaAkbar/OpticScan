import 'package:get/get.dart';

import '../modules/eyescanner/bindings/eyescanner_binding.dart';
import '../modules/eyescanner/views/eyescanner_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/signup/bindings/signup_binding.dart';
import '../modules/signup/views/signup_view.dart';
import '../modules/splashscreen/bindings/splashscreen_binding.dart';
import '../modules/splashscreen/views/splashscreen_view.dart';
import '../shared/bindings/main_binding.dart';
import '../shared/widgets/main_layout.dart';
part 'app_routes.dart';

// ROUTE UNTUK NAVIGASI
class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASHSCREEN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const MainLayout(currentRoute: Routes.HOME),
      binding: MainBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => const SignupView(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: _Paths.SPLASHSCREEN,
      page: () => const SplashscreenView(),
      binding: SplashscreenBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const MainLayout(currentRoute: Routes.PROFILE),
      binding: MainBinding(),
    ),
    GetPage(
      name: _Paths.RIWAYAT,
      page: () => const MainLayout(currentRoute: Routes.RIWAYAT),
      binding: MainBinding(),
    ),
    GetPage(
      name: _Paths.EYESCANNER,
      page: () => const EyescannerView(),
      binding: EyescannerBinding(),
    ),
  ];
}
