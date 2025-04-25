import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:opticscan/app/routes/app_pages.dart';
import 'package:opticscan/services/examination_service.dart';
import 'package:opticscan/utils/constants/api_constants.dart';

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

  // Factory constructor to create an ExaminationRecord from backend JSON
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

  // Get the full URL for the eye image
  String get eyeImageUrl => '${ApiConstants.eyeImageBaseUrl}$eyePic';
}

class RiwayatController extends GetxController {
  final ExaminationService _examinationService = Get.find<ExaminationService>();

  // Tab selection
  final selectedTab = 0.obs; // 0 = On Progress, 1 = Selesai

  // Bottom navbar selection
  final selectedNavIndex = 1.obs; // 1 = Riwayat tab

  // Single data source for all examinations
  final allExaminations = <ExaminationRecord>[].obs;

  // Loading state
  final isLoading = false.obs;

  // Error state
  final errorMessage = ''.obs;
  final hasError = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Load real data from backend
    fetchExaminationRecords();
  }

  // Fetch examination records from backend
  Future<void> fetchExaminationRecords() async {
    isLoading.value = true;
    hasError.value = false;

    try {
      final response = await _examinationService.getExaminationResults();

      if (response.success && response.data != null) {
        // Convert backend data to ExaminationRecord objects
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

  // Refresh examination records (pull-to-refresh)
  Future<void> refreshExaminations() async {
    await fetchExaminationRecords();
  }

  // Get filtered examinations based on selected tab
  List<ExaminationRecord> get filteredExaminations {
    return selectedTab.value == 0
        ? allExaminations.where((exam) => exam.status == 'On Review').toList()
        : allExaminations.where((exam) => exam.status == 'Completed').toList();
  }

  // Change tab
  void changeTab(int index) {
    selectedTab.value = index;
  }

  // Navigation method for bottom navbar
  void onNavItemTapped(int index) {
    selectedNavIndex.value = index;

    // Navigate based on the selected index
    switch (index) {
      case 0: // Home
        Get.offAllNamed(Routes.HOME);
        break;
      case 1: // Riwayat
        // Already on riwayat, no need to navigate
        break;
      case 2: // Profile
        Get.offAllNamed(Routes.PROFILE);
        break;
    }
  }

  // Format date to day of week
  String getDayOfWeek(DateTime date) {
    // Using intl package to get day of week
    return DateFormat('EEEE').format(date);
  }

  // Format date to DD-MM-YYYY
  String formatDate(DateTime date) {
    // Using intl package for date formatting
    return DateFormat('dd-MM-yyyy').format(date);
  }
}
