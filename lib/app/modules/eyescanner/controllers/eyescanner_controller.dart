import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';

class EyescannerController extends GetxController {
  final count = 0.obs;
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
  void onReady() {
    super.onReady();
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
            cameras[selectedCameraIndex.value], ResolutionPreset.high);

        await cameraController.value!.initialize();
        isCameraInitialized.value = true;
      }
    } catch (e) {
      print("Error initializing camera: $e");
    }
  }

  Future<void> switchCamera() async {
    if (cameras.length > 1) {
      selectedCameraIndex.value =
          (selectedCameraIndex.value + 1) % cameras.length;

      if (cameraController.value != null) {
        await cameraController.value!.dispose();
      }

      cameraController.value = CameraController(
          cameras[selectedCameraIndex.value], ResolutionPreset.high);

      await cameraController.value!.initialize();
    }
  }

  Future<void> takePicture() async {
    if (cameraController.value != null &&
        cameraController.value!.value.isInitialized) {
      try {
        final XFile? file = await cameraController.value!.takePicture();
        if (file != null) {
          print("Foto disimpan di: ${file.path}");
          // You can add code here to handle the taken picture
        }
      } catch (e) {
        print("Error taking picture: $e");
      }
    }
  }

  Future<void> pickImageFromGallery() async {
    try {
      final XFile? image =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        print("Gambar dari galeri: ${image.path}");
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }
}
