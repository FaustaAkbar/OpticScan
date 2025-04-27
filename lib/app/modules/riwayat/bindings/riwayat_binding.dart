import 'package:get/get.dart';
import 'package:opticscan/app/modules/riwayat/controllers/riwayat_controller.dart';
import 'package:opticscan/services/examination_service.dart';

class RiwayatBinding extends Bindings {
  @override
  void dependencies() {
    // ========= memastikan ExaminationService diinisialisasi =========
    if (!Get.isRegistered<ExaminationService>()) {
      Get.put(ExaminationService().init());
    }
    Get.lazyPut<RiwayatController>(
      () => RiwayatController(),
    );
  }
}
