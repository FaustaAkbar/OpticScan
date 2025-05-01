import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:IntelliSight/app/routes/app_pages.dart';
import 'package:IntelliSight/services/examination_service.dart';
import 'package:IntelliSight/utils/constants/api_constants.dart';

class ExaminationRecord {
  final int examinationId;
  final int patientId;
  final int? doctorId;
  final DateTime examinationDate;
  final String eyePic;
  final String? complaints;
  final String diagnosis;
  final String? doctorsNote;
  final String status;
  final String patientName;
  final String? doctorName;

  ExaminationRecord({
    required this.examinationId,
    required this.patientId,
    this.doctorId,
    required this.examinationDate,
    required this.eyePic,
    this.complaints,
    required this.diagnosis,
    this.doctorsNote,
    required this.status,
    required this.patientName,
    this.doctorName,
  });

  // ========= membuat objek ExaminationRecord dari data JSON dari backend =========
  factory ExaminationRecord.fromJson(Map<String, dynamic> json) {
    return ExaminationRecord(
      examinationId: json['examination_id'],
      patientId: json['patient_id'],
      doctorId: json['doctor_id'],
      examinationDate: DateTime.parse(json['examination_date']),
      eyePic: json['eye_pic'],
      complaints: json['complaints'],
      diagnosis: json['diagnosis'],
      doctorsNote: json['doctors_note'],
      status: json['status'] == 'ongoing' ? 'On Review' : 'Completed',
      patientName: json['patient']?['name'] ?? 'Unknown',
      doctorName: json['doctor']?['name'],
    );
  }

  String get eyeImageUrl => '${ApiConstants.eyeImageBaseUrl}$eyePic';
}

class RiwayatController extends GetxController {
  final ExaminationService _examinationService = Get.find<ExaminationService>();
  final selectedTab = 0.obs; // 0 = On Progress, 1 = Selesai
  final selectedNavIndex = 1.obs; // 1 = Riwayat tab
  final allExaminations = <ExaminationRecord>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final hasError = false.obs;

  @override
  void onInit() {
    super.onInit();
    // mengambil data pemeriksaan dari backend
    fetchExaminationRecords();
  }

  // ========= mengambil data pemeriksaan dari backend =========
  Future<void> fetchExaminationRecords() async {
    isLoading.value = true;
    hasError.value = false;
    try {
      final response = await _examinationService.getExaminationResults();
      if (response.success && response.data != null) {
        // Mengubah data backend menjadi objek ExaminationRecord
        final List<dynamic> examinationsData = response.data;
        allExaminations.value = examinationsData
            .map((data) => ExaminationRecord.fromJson(data))
            .toList();
      } else {
        hasError.value = true;
        errorMessage.value = response.message;
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to load examination records';
    } finally {
      isLoading.value = false;
    }
  }

  // ========= memperbarui data pemeriksaan (pull-to-refresh) =========
  Future<void> refreshExaminations() async {
    await fetchExaminationRecords();
  }

  // ========= mengambil data pemeriksaan berdasarkan tab yang dipilih =========
  List<ExaminationRecord> get filteredExaminations {
    return selectedTab.value == 0
        ? allExaminations.where((exam) => exam.status == 'On Review').toList()
        : allExaminations.where((exam) => exam.status == 'Completed').toList();
  }

  // ========= mengubah tab =========
  void changeTab(int index) {
    selectedTab.value = index;
  }

  // ========= navigasi untuk navbar bawah =========
  void onNavItemTapped(int index) {
    selectedNavIndex.value = index;
    switch (index) {
      case 0: // Home
        Get.offAllNamed(Routes.HOME);
        break;
      case 1: // Riwayat
        break;
      case 2: // Profile
        Get.offAllNamed(Routes.PROFILE);
        break;
    }
  }

  // ========= format tanggal ke hari =========
  String getDayOfWeek(DateTime date) {
    return DateFormat('EEEE').format(date);
  }

  // ========= format tanggal ke DD-MM-YYYY =========
  String formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }
}
