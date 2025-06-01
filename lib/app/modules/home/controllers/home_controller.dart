import 'package:get/get.dart';

import 'package:IntelliSight/app/routes/app_pages.dart';
import 'package:IntelliSight/services/api_service.dart';

class HomeController extends GetxController {
  final count = 0.obs;
  final selectedIndex = 0.obs;
  final totalScans = 0.obs;
  final totalPasien = 0.obs;
  final totalDokter = 0.obs;

  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    fetchUserCounts();
  }

  void increment() => count.value++;

  void onItemTapped(int index) {
    selectedIndex.value = index;
    switch (index) {
      case 0:
        Get.offAllNamed(Routes.HOME);
        break;
      case 1:
        Get.offAllNamed(Routes.RIWAYAT);
        break;
      case 2:
        Get.offAllNamed(Routes.PROFILE);
        break;
    }
  }

  void fetchUserCounts() async {
    try {
      final result = await _apiService.fetchUserCounts();
      totalPasien.value = result.data['total_pasien'] ?? 0;
      totalDokter.value = result.data['total_dokter'] ?? 0;
    } catch (e) {
      //
    }
  }
}
