import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opticscan/form_submit/eye_scanner_result_controller.dart';

class EyeScanResultScreen extends StatelessWidget {
  final String imagePath;

  const EyeScanResultScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final EyeScanResultController _controller =
        Get.put(EyeScanResultController());

    _controller.imageFile.value = File(imagePath);

    return Scaffold(
      backgroundColor: const Color(0XFFE2E9F1),
      appBar: AppBar(
        backgroundColor: const Color(0XFFE2E9F1),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Obx(() {
        return ListView(
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 270),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          File(imagePath),
                          width: 240,
                          height: 170,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0XFF146EF5),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Ambil Ulang',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 45),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: TextField(
                  controller: _controller.complaintController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: "Masukkan keluhan Anda",
                    hintStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              height: 30,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 130),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0XFF146EF5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async {
                    await _controller.submitScan();
                  },
                  child: _controller.isLoading.value
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.send,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Kirim',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
