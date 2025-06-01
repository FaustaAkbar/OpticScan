import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:IntelliSight/form_submit/Eye_Scanner_Result.dart';

class EyescannerController extends GetxController {
  final isCameraInitialized = false.obs;
  final selectedCameraIndex = 0.obs;

  Rx<CameraController?> cameraController = Rx<CameraController?>(null);
  RxList<CameraDescription> cameras = RxList<CameraDescription>([]);

  @override
  void onInit() {
    super.onInit();
    initCamera();
  }

  @override
  void onClose() {
    cameraController.value?.dispose();
    super.onClose();
  }

  Future<void> initCamera() async {
    try {
      cameras.value = await availableCameras();
      if (cameras.isNotEmpty) {
        cameraController.value = CameraController(
          cameras[selectedCameraIndex.value],
          ResolutionPreset.high,
        );

        await cameraController.value!.initialize();
        isCameraInitialized.value = true;
      }
    } catch (e) {
      // Handle the error
    }
  }

  Future<void> switchCamera() async {
    if (cameras.length > 1) {
      selectedCameraIndex.value =
          (selectedCameraIndex.value + 1) % cameras.length;

      if (cameraController.value != null) {
        await cameraController.value!.dispose();
      }

      final newController = CameraController(
        cameras[selectedCameraIndex.value],
        ResolutionPreset.high,
      );

      try {
        await newController.initialize();

        cameraController.value = newController;

        isCameraInitialized.value = true;
      } catch (e) {
        print("Error switching camera: $e");
        isCameraInitialized.value = false;
      }
    }
  }

  Future<String?> takePicture() async {
    if (cameraController.value != null &&
        cameraController.value!.value.isInitialized) {
      try {
        final XFile file = await cameraController.value!.takePicture();
        return file.path;
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Future<String?> pickImageFromGallery() async {
    try {
      final XFile? image =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        Get.to(() => EyeScanResultScreen(imagePath: image.path));
      }
    } catch (e) {
      // Handle the error
    }
    return null;
  }
}
