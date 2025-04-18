import 'package:get/get.dart';
import 'package:opticscan/app/routes/app_pages.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  final count = 0.obs;
  final selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  void onItemTapped(int index) {
    selectedIndex.value = index;

    // Navigate based on the selected index
    switch (index) {
      case 0: // Home
        Get.offAllNamed(Routes.HOME);
        break;
      case 1: // Riwayat
        Get.offAllNamed(Routes.RIWAYAT);
        break;
      case 2: // Profile
        Get.offAllNamed(Routes.PROFILE);
        break;
    }
  }
}
