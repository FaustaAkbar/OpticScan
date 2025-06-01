import 'package:get/get.dart';
import 'package:IntelliSight/services/api_service.dart';
import 'package:IntelliSight/services/examination_service.dart';
import 'package:IntelliSight/services/user_service.dart';

/// ========= binding awal =========
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ApiService(), permanent: true);

    Get.putAsync<UserService>(
      () => UserService().init(),
      permanent: true,
    );

    Get.putAsync<ExaminationService>(
      () => ExaminationService().init(),
      permanent: true,
    );
  }
}
