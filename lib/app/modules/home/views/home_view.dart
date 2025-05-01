import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:IntelliSight/app/routes/app_pages.dart';
import 'package:IntelliSight/app/shared/bindings/main_binding.dart';
import 'package:IntelliSight/app/shared/widgets/main_layout.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFE2E9F1),
      appBar: AppBar(
        backgroundColor: Color(0XFFE2E9F1),
        elevation: 0,
        title: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Hello,",
                    style: TextStyle(color: Colors.grey, fontSize: 16)),
                Text("Hi James",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black)),
              ],
            ),
            const Spacer(),
            CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: const Icon(Icons.emoji_emotions, color: Colors.blue),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(
              height: 50,
            ),
            // Info Cards
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                infoCard("Total Scans", "64", LucideIcons.scanLine),
                SizedBox(
                  width: 10,
                ),
                infoCard("Total Doctor", "32", LucideIcons.stethoscope),
              ],
            ),
            const SizedBox(height: 28),

            // Services
            Row(
              children: [
                Expanded(
                  child: InkWell(
                      onTap: () {
                        // Navigate to eye scanner screen
                        Get.toNamed(Routes.EYESCANNER);
                      },
                      child: serviceCard(
                          LucideIcons.eye, "Eyes Scan", "Menggunakan AI")),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                      onTap: () {
                        Get.offAll(
                          () => MainLayout(currentRoute: Routes.RIWAYAT),
                          binding: MainBinding(),
                          transition: Transition.noTransition,
                        );
                      },
                      child: serviceCard(LucideIcons.fileSearch, "Scan History",
                          "Hasil Scan Anda")),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Recently Scanning
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Recently Scanning",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text("See All", style: TextStyle(color: Color(0XFF9E9E9E))),
              ],
            ),
            const SizedBox(height: 21),
            scanHistoryCard("Dr Alan", "17-02-2025", "Cataracts"),
            SizedBox(
              height: 13,
            ),
            scanHistoryCard("Dr Alan", "17-02-2025", "Cataracts"),
          ],
        ),
      ),
    );
  }

  Widget infoCard(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        height: 110,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5)],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Color(0XFF146EF5), fontSize: 16)),
                Text(value,
                    style: const TextStyle(
                        color: Color(0XFF146EF5),
                        fontSize: 32,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Icon(icon, color: Color(0XFF146EF5), size: 45),
            ),
          ],
        ),
      ),
    );
  }

  Widget serviceCard(IconData icon, String title, String subtitle) {
    return Expanded(
      child: Container(
        height: 160,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0XFF146EF5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 43, color: Colors.white),
            const SizedBox(height: 10),
            Text(title,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            Text(subtitle,
                style: const TextStyle(fontSize: 14, color: Colors.white70)),
          ],
        ),
      ),
    );
  }

  Widget scanHistoryCard(String doctor, String date, String diagnosis) {
    return Container(
      height: 74,
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5)],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(doctor,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                Row(
                  children: [
                    const Icon(Icons.access_time,
                        size: 12, color: Color(0XFF146EF5)),
                    Text(" $date",
                        style: const TextStyle(
                            color: Color(0XFF146EF5),
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(diagnosis,
                style: TextStyle(
                    color: Colors.red.shade900,
                    fontSize: 14,
                    fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
