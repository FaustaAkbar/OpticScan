import 'package:get/get.dart';
import 'package:opticscan/services/api_service.dart';
import 'package:opticscan/services/examination_service.dart';
import 'package:opticscan/services/user_service.dart';

/// ========= binding awal =========
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // inisialisasi service API
    Get.put(ApiService(), permanent: true);

    // inisialisasi service User
    Get.putAsync<UserService>(
      () => UserService().init(),
      permanent: true,
    );

    // inisialisasi service Examination
    Get.putAsync<ExaminationService>(
      () => ExaminationService().init(),
      permanent: true,
    );
  }
}
