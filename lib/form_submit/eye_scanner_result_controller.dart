import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opticscan/form_submit/eye_scan_result_service.dart';
import 'package:opticscan/services/user_service.dart';

class EyeScanResultController extends GetxController {
  final complaintController = TextEditingController();
  final Rx<File?> imageFile = Rx<File?>(null);
  final isLoading = false.obs;

  final EyeScanResultService _scanService = EyeScanResultService();
  final UserService _userService = Get.find<UserService>();

  // Submit data scan
  Future<void> submitScan() async {
    final complaint = complaintController.text.trim();
    final image = imageFile.value;

    if (complaint.isEmpty || image == null) {
      Get.snackbar('Error', 'Lengkapi semua data!',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading.value = true;

    try {
      // (opsional) ambil userId
      final userId = _userService.userId;

      final response = await _scanService.submitScan(
        complaint: complaint,
        image: image,
      );

      if (response.success) {
        Get.snackbar('Berhasil', response.message,
            backgroundColor: Colors.green, colorText: Colors.white);
        complaintController.clear();
        imageFile.value = null;
      } else {
        Get.snackbar('Gagal', response.message,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan!',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}
