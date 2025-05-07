import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opticscan/form_submit/eye_scan_result_service.dart';
import 'package:opticscan/services/user_service.dart';

class EyeScanResultController extends GetxController {
  final nameController = TextEditingController(); // Tambahkan ini
  final complaintController = TextEditingController();
  final Rx<File?> imageFile = Rx<File?>(null);
  final isLoading = false.obs;

  final EyeScanResultService _scanService = EyeScanResultService();
  final UserService _userService = Get.find<UserService>();

  Future<void> submitScan() async {
    final name = nameController.text.trim(); // Ambil nama
    final complaint = complaintController.text.trim();
    final image = imageFile.value;

    if (name.isEmpty || complaint.isEmpty || image == null) {
      Get.snackbar('Error', 'Lengkapi semua data!',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading.value = true;

    try {
      final response = await _scanService.submitScan(
        name: name, // Kirim nama
        complaint: complaint,
        image: image,
      );

      if (response.success) {
        Get.snackbar('Berhasil', response.message,
            backgroundColor: Colors.green, colorText: Colors.white);
        nameController.clear(); // Reset nama
        complaintController.clear(); // Reset keluhan
        imageFile.value = null; // Reset gambar
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
