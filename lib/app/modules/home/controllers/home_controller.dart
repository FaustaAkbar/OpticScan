import 'package:get/get.dart';

import 'package:opticscan/app/routes/app_pages.dart';
import 'package:opticscan/services/api_service.dart';

class HomeController extends GetxController {
  final count = 0.obs;
  final selectedIndex = 0.obs;
  final totalScans = 0.obs;
  final totalPasien = 0.obs;
  final totalDokter = 0.obs;

  final ApiService _apiService = ApiService(); // Tambahkan ApiService

  @override
  void onInit() {
    super.onInit();
    fetchUserCounts(); // Ambil data saat inisialisasi
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

  // Tambahkan method untuk fetch user counts
  void fetchUserCounts() async {
    try {
      final result = await _apiService.fetchUserCounts();
      totalPasien.value = result['total_pasien'] ?? 0;
      totalDokter.value = result['total_dokter'] ?? 0;
    } catch (e) {
      print('Gagal mengambil data user count: $e');
    }
  }
}
