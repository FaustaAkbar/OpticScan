import 'dart:io';
import 'package:dio/dio.dart';
import 'package:opticscan/services/api_service.dart';
import 'package:opticscan/utils/constants/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EyeScanResultService {
  final Dio _dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrlEmulator));

  Future<ApiResponse> submitScan({
    required String complaint,
    required File image,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(ApiConstants.accessTokenKey);

      if (token == null) {
        return ApiResponse(success: false, message: 'Token tidak ditemukan');
      }

      final formData = FormData.fromMap({
        'complaint': complaint,
        'image': await MultipartFile.fromFile(image.path, filename: 'scan.jpg'),
      });

      final response = await _dio.post(
        ApiConstants.submitExamEndpoint, // misal: '/api/eye-scan'
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      return ApiResponse(
        success: true,
        message: response.data['message'] ?? 'Scan berhasil dikirim',
        data: response.data['data'],
      );
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? 'Gagal mengirim scan';
      return ApiResponse(success: false, message: errorMessage);
    } catch (_) {
      return ApiResponse(success: false, message: 'Terjadi kesalahan');
    }
  }
}
