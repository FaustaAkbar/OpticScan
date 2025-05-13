import 'package:get/get.dart';
import 'package:IntelliSight/app/modules/home/controllers/home_controller.dart';
import 'package:IntelliSight/app/modules/profile/controllers/profile_controller.dart';
import 'package:IntelliSight/app/modules/riwayat/controllers/riwayat_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    // inisialisasi controller
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<RiwayatController>(() => RiwayatController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
