import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:IntelliSight/app/modules/riwayat/controllers/riwayat_controller.dart';
import 'package:IntelliSight/app/routes/app_pages.dart';
import 'package:IntelliSight/app/shared/bindings/main_binding.dart';
import 'package:IntelliSight/app/shared/widgets/main_layout.dart';
import 'package:IntelliSight/app/modules/profile/controllers/profile_controller.dart';
import 'package:IntelliSight/utils/constants/api_constants.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileController>();
    final riwayatController = Get.find<RiwayatController>();
    final homeController = Get.find<HomeController>();

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
                Obx(() => Text(
                      "Hi ${profileController.name.value}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    )),
              ],
            ),
            const Spacer(),
            Obx(() => CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage:
                      (profileController.profilePic.value.isNotEmpty &&
                              Uri.tryParse(profileController.profileImageUrl)
                                      ?.hasAbsolutePath ==
                                  true)
                          ? NetworkImage(
                              // '${ApiConstants.baseUrlEmulator}/${profileController.profileImageUrl}',
                              '${ApiConstants.baseUrlEmulator}/images/profile-pics/${profileController.profilePic.value}',
                            )
                          : null,
                ))
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
                Obx(() => infoCard(
                      "Total Scans",
                      riwayatController.totalScans.value.toString(),
                      LucideIcons.scanLine,
                    )),
                SizedBox(
                  width: 10,
                ),
                Obx(() => infoCard(
                      "Total Dokter",
                      homeController.totalDokter.value.toString(),
                      LucideIcons.scanLine,
                    )),
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
            Obx(() {
              final exams = riwayatController.filteredExaminations;
              if (exams.isEmpty) {
                return const Center(child: Text("Belum ada riwayat."));
              }

              return Column(
                children: exams
                    .map((examination) => Column(
                          children: [
                            scanHistoryCard(
                              examination.doctorName ?? 'Unknown',
                              riwayatController
                                  .formatDate(examination.examinationDate),
                              examination.diagnosis,
                            ),
                            const SizedBox(height: 13),
                          ],
                        ))
                    .toList(),
              );
            }),
            SizedBox(
              height: 13,
            ),
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
