import 'package:get/get.dart';
import 'package:opticscan/app/modules/home/controllers/home_controller.dart';
import 'package:opticscan/app/modules/profile/controllers/profile_controller.dart';
import 'package:opticscan/app/modules/riwayat/controllers/riwayat_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    // INISIALISASI SEMUA CONTROLLER YANG MUNGKIN DIBUTUHKAN
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<RiwayatController>(() => RiwayatController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
