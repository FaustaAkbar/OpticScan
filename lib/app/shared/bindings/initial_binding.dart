import 'package:get/get.dart';
import 'package:opticscan/services/api_service.dart';
import 'package:opticscan/services/examination_service.dart';
import 'package:opticscan/services/user_service.dart';

/// This binding is executed before any route is loaded
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize API Service first
    Get.put(ApiService(), permanent: true);

    // Initialize UserService as a global service that persists throughout the app lifecycle
    Get.putAsync<UserService>(
      () => UserService().init(),
      permanent: true, // Keep it alive throughout the app
    );

    // Initialize ExaminationService
    Get.putAsync<ExaminationService>(
      () => ExaminationService().init(),
      permanent: true,
    );
  }
}
