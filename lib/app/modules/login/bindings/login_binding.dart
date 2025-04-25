import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    // UserService is now initialized in InitialBinding
    Get.put<LoginController>(
      LoginController(),
    );
  }
}
