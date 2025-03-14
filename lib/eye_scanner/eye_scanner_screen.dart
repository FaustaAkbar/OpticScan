import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EyeScannerScreen extends StatefulWidget {
  @override
  _EyeScannerScreenState createState() => _EyeScannerScreenState();
}

class _EyeScannerScreenState extends State<EyeScannerScreen> {
  CameraController? _controller;
  List<CameraDescription>? cameras;
  bool _isCameraInitialized = false;
  int _selectedCameraIndex = 0;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    cameras = await availableCameras();
    _controller =
        CameraController(cameras![_selectedCameraIndex], ResolutionPreset.high);

    await _controller!.initialize();
    if (mounted) {
      setState(() {
        _isCameraInitialized = true;
      });
    }
  }

  Future<void> _switchCamera() async {
    if (cameras!.length > 1) {
      setState(() {
        _selectedCameraIndex = (_selectedCameraIndex + 1) % cameras!.length;
      });
      await _initCamera();
    }
  }

  Future<void> _pickImageFromGallery() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      print("Gambar dari galeri: ${image.path}");
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Kamera Preview
          if (_isCameraInitialized && _controller != null)
            Positioned.fill(
              child: CameraPreview(_controller!),
            ),

          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.cached, color: Colors.white, size: 32),
              onPressed: _switchCamera,
            ),
          ),

          // Overlay Frame Scan Mata
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                    height: 50), // Memberi jarak antara atas dan teks

                // Teks Judul
                const Text(
                  "Ambil gambar mata",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),

                // Kotak Fokus Scanner
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

                // Tombol Kamera dan Galeri
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 50),
                        child: IconButton(
                          icon: const Icon(Icons.image,
                              color: Colors.white, size: 32),
                          onPressed: _pickImageFromGallery,
                        ),
                      ),
                      // Spacer untuk menyesuaikan posisi di tengah

                      GestureDetector(
                        onTap: () async {
                          final XFile? file = await _controller!.takePicture();
                          if (file != null) {
                            print("Foto disimpan di: ${file.path}");
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
                      // Spacer agar tetap seimbang
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
