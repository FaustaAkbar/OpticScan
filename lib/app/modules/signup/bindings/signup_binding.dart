import 'package:get/get.dart';

import '../controllers/signup_controller.dart';

class SignupBinding extends Bindings {
  @override
  void dependencies() {
    // UserService is now initialized in InitialBinding
    Get.put<SignupController>(
      SignupController(),
      permanent: true,
    );
  }
}
