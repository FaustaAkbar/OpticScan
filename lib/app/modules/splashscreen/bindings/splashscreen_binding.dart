import 'package:get/get.dart';
import '../controllers/splashscreen_controller.dart';

class SplashscreenBinding extends Bindings {
  @override
  void dependencies() {
    // service User sudah diinisialisasi di InitialBinding, jangan coba inisialisasi lagi
    Get.lazyPut<SplashscreenController>(
      () => SplashscreenController(),
    );
  }
}
