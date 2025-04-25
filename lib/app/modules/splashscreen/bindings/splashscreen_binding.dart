import 'package:get/get.dart';

import '../controllers/splashscreen_controller.dart';
import 'package:opticscan/services/user_service.dart';

class SplashscreenBinding extends Bindings {
  @override
  void dependencies() {
    // UserService is now initialized in InitialBinding, don't try to initialize again
    Get.lazyPut<SplashscreenController>(
      () => SplashscreenController(),
    );
  }
}
