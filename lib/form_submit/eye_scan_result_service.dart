import 'dart:io';
import 'package:dio/dio.dart';
import 'package:IntelliSight/services/api_service.dart';
import 'package:IntelliSight/utils/constants/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';

class EyeScanResultService {
  final Dio _dio = Dio();

  Future<ApiResponse> submitScan({
    required String? name,
    required String complaint,
    required File image,
  }) async {
    try {
      final extension = path.extension(image.path).toLowerCase();
      if (extension != '.jpg' && extension != '.jpeg' && extension != '.png') {
        return ApiResponse(
            success: false,
            message:
                'Format file tidak didukung. Hanya file JPG, JPEG, dan PNG yang diperbolehkan.');
      }

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(ApiConstants.accessTokenKey);

      if (token == null) {
        return ApiResponse(success: false, message: 'Token tidak ditemukan');
      }

      String mimeType;
      if (extension == '.jpg' || extension == '.jpeg') {
        mimeType = 'image/jpeg';
      } else if (extension == '.png') {
        mimeType = 'image/png';
      } else {
        return ApiResponse(
            success: false, message: 'Format file tidak didukung.');
      }

      final formData = FormData.fromMap({
        if (name != null) 'name': name,
        'complaints': complaint,
        'eye_pic': await MultipartFile.fromFile(
          image.path,
          filename: path.basename(image.path),
          contentType: MediaType.parse(mimeType),
        ),
      });

      final response = await _dio.post(
        ApiConstants.submitExamEndpoint,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
          validateStatus: (status) {
            return status != null && status < 500;
          },
        ),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        return ApiResponse(
          success: false,
          message: response.data['message'] ??
              'Server returned error code ${response.statusCode}',
        );
      }

      return ApiResponse(
        success: true,
        message: response.data['message'] ?? 'Scan berhasil dikirim',
        data: response.data['data'],
      );
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? 'Gagal mengirim scan';
      return ApiResponse(success: false, message: errorMessage);
    } catch (e) {
      return ApiResponse(success: false, message: 'Terjadi kesalahan');
    }
  }
}
