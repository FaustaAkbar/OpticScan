import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:opticscan/app/routes/app_pages.dart';
import 'package:opticscan/app/shared/bindings/main_binding.dart';
import 'package:opticscan/app/shared/widgets/main_layout.dart';
import 'package:opticscan/form_submit/Eye_Scanner_Result.dart';

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
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
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
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.cached, color: Colors.white, size: 32),
              onPressed: controller.switchCamera,
            ),
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 50),
                const Text(
                  "Ambil gambar mata",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.orange, width: 3),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 0),
                        child: IconButton(
                          icon: const Icon(Icons.image,
                              color: Colors.white, size: 32),
                          onPressed: controller.pickImageFromGallery,
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          final imagePath = await controller.takePicture();
                          if (imagePath != null) {
                            Get.to(() =>
                                EyeScanResultScreen(imagePath: imagePath));
                          } else {
                            Get.snackbar('Error', 'Gagal mengambil gambar',
                                backgroundColor: Colors.red,
                                colorText: Colors.white);
                          }
                        },
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
