import 'package:get/get.dart';
import 'package:IntelliSight/services/api_service.dart';

class ExaminationService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();

  // ========= ambil data hasil pemeriksaan =========
  Future<ApiResponse> getExaminationResults() async {
    return await _apiService.getExaminationResults();
  }

  // ========= submit pemeriksaan (upload gambar mata) =========
  Future<ApiResponse> submitExamination({
    required String imagePath,
    String? complaints,
  }) async {
    return await _apiService.submitExamination(
      imagePath: imagePath,
      complaints: complaints,
    );
  }

  // ========= initialize service =========
  Future<ExaminationService> init() async {
    return this;
  }
}
