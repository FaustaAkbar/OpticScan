import 'package:get/get.dart';
import 'package:opticscan/services/api_service.dart';

class ExaminationService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();

  // Get all examination results for the current user
  Future<ApiResponse> getExaminationResults() async {
    return await _apiService.getExaminationResults();
  }

  // Submit a new examination
  Future<ApiResponse> submitExamination({
    required String imagePath,
    String? complaints,
  }) async {
    return await _apiService.submitExamination(
      imagePath: imagePath,
      complaints: complaints,
    );
  }

  // Initialize the service
  Future<ExaminationService> init() async {
    return this;
  }
}
