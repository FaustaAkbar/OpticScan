import 'dart:io';
import 'package:flutter/material.dart';

class EyeScanResultScreen extends StatefulWidget {
  final String imagePath;

  const EyeScanResultScreen({super.key, required this.imagePath});

  @override
  State<EyeScanResultScreen> createState() => _EyeScanResultScreenState();
}

class _EyeScanResultScreenState extends State<EyeScanResultScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _complaintController = TextEditingController();
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // You can add listeners to the focus node if needed
    _focusNode.addListener(() {
      setState(() {}); // This will refresh the widget when focus changes
    });
  }

  void dispose() {
    _nameController.dispose();
    _complaintController.dispose();
    super.dispose();
    _focusNode.dispose();
  }

  void _submitData() {
    final name = _nameController.text;
    final complaint = _complaintController.text;
    final image = widget.imagePath;

    if (name.isEmpty || complaint.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama dan keluhan harus diisi!')),
      );
      return;
    }

    // Untuk sekarang, cetak dulu ke console
    print('Nama: $name');
    print('Keluhan: $complaint');
    print('Image Path: $image');

    // TODO: Kirim data ke API nanti di sini
  }

  @override
  Widget build(BuildContext context) {
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
      body: ListView(
        children: [
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 270,
              ),
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
                        File(widget.imagePath),
                        width: 240,
                        height: 170,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0XFF146EF5),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                      ),
                      label: Text(
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
                color: Colors.white, // Full putih
                borderRadius: BorderRadius.circular(6), // Bulatkan sudut
              ),
              child: TextField(
                controller: _nameController,
                focusNode: _focusNode,
                decoration: const InputDecoration(
                  hintText: "Masukkan Nama Anda",
                  hintStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                  border: InputBorder.none, // Hapus border outline
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // Full putih
                borderRadius: BorderRadius.circular(6), // Bulatkan sudut
              ),
              child: TextField(
                controller: _complaintController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: "Masukan keluhan anda",
                  hintStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none, // Hapus border outline
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
                  backgroundColor: Color(0XFF146EF5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _submitData,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/icons/send_icon.png',
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 8),
                    const Text(
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
      ),
    );
  }
}
