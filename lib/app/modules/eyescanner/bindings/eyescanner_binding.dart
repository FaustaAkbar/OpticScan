import 'package:get/get.dart';

import '../controllers/eyescanner_controller.dart';

class EyescannerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EyescannerController>(
      () => EyescannerController(),
    );
  }
}
