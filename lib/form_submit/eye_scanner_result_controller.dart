import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:IntelliSight/form_submit/eye_scan_result_service.dart';
import 'package:IntelliSight/services/user_service.dart';

class EyeScanResultController extends GetxController {
  final nameController = TextEditingController(); // Tambahkan ini
  final complaintController = TextEditingController();
  final Rx<File?> imageFile = Rx<File?>(null);
  final isLoading = false.obs;

  final EyeScanResultService _scanService = EyeScanResultService();
  final UserService _userService = Get.find<UserService>();

  Future<void> submitScan() async {
    final name = nameController.text.trim();
    final complaint = complaintController.text.trim();
    final image = imageFile.value;

    if (name.isEmpty || complaint.isEmpty || image == null) {
      Get.snackbar('Error', 'Complete all data!',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading.value = true;

    try {
      final response = await _scanService.submitScan(
        name: name,
        complaint: complaint,
        image: image,
      );

      if (response.success) {
        _showSuccessDialog(response.message);
        nameController.clear();
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

  void _showSuccessDialog(String message) {
    isLoading.value = false;
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // icon sukses
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Color(0xFF146EF5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // judul sukses
              const Text(
                'Data Sent Successfully',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),

              // pesan sukses
              const Text(
                'Please wait for the results',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 24),

              // tombol kembali
              Center(
                child: SizedBox(
                  width: 219,
                  height: 29,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF146EF5),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(
                          color: Color(0xFF146EF5),
                          width: 2,
                        ),
                      ),
                    ),
                    child: const Text(
                      'Ok',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
