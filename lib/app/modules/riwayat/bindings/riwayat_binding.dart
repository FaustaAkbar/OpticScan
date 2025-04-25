import 'package:get/get.dart';
import 'package:opticscan/app/modules/riwayat/controllers/riwayat_controller.dart';
import 'package:opticscan/services/examination_service.dart';

class RiwayatBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure ExaminationService is initialized
    if (!Get.isRegistered<ExaminationService>()) {
      Get.put(ExaminationService().init());
    }

    // Register the controller
    Get.lazyPut<RiwayatController>(
      () => RiwayatController(),
    );
  }
}
