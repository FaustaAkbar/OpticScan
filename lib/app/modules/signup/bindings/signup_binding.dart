import 'package:get/get.dart';

import '../controllers/signup_controller.dart';

class SignupBinding extends Bindings {
  @override
  void dependencies() {
    // service User sudah diinisialisasi di InitialBinding, jangan coba inisialisasi lagi
    Get.put<SignupController>(
      SignupController(),
    );
  }
}
