import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:IntelliSight/app/routes/app_pages.dart';
import 'package:IntelliSight/app/shared/bindings/main_binding.dart';
import 'package:IntelliSight/app/shared/widgets/main_layout.dart';
import 'package:IntelliSight/form_submit/Eye_Scanner_Result.dart';

import '../controllers/eyescanner_controller.dart';

class EyescannerView extends GetView<EyescannerController> {
  const EyescannerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.offAll(
              () => MainLayout(currentRoute: Routes.HOME),
              binding: MainBinding(),
              transition: Transition.noTransition,
            );
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera Preview
          Obx(() {
            if (controller.isCameraInitialized.value &&
                controller.cameraController.value != null) {
              return Positioned.fill(
                child: CameraPreview(controller.cameraController.value!),
              );
            } else {
              return const SizedBox.shrink();
            }
          }),

          // Switch Camera Icon (Top Right)
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.cached, color: Colors.white, size: 32),
              onPressed: controller.switchCamera,
            ),
          ),

          // Camera Guide Box and Title
          Positioned.fill(
            child: Column(
              children: [
                const SizedBox(height: 50),
                const Text(
                  "Ambil gambar mata",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.orange, width: 3),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Tombol kamera di tengah bawah
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: GestureDetector(
                onTap: () async {
                  final imagePath = await controller.takePicture();
                  if (imagePath != null) {
                    Get.to(() => EyeScanResultScreen(imagePath: imagePath));
                  } else {
                    Get.snackbar('Error', 'Gagal mengambil gambar',
                        backgroundColor: Colors.red, colorText: Colors.white);
                  }
                },
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          // Tombol galeri di kiri bawah
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 40, bottom: 30),
              child: GestureDetector(
                onTap: controller.pickImageFromGallery,
                child: const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 28,
                  child: Icon(Icons.image, color: Colors.blue, size: 28),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
