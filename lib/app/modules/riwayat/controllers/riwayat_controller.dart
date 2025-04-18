import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:opticscan/app/routes/app_pages.dart';

class ExaminationRecord {
  final String name;
  final DateTime date;
  final String status;
  final String avatarUrl;
  final String aiDiagnosis;
  final String doctorDiagnosis;
  final String doctorName;
  final String doctorNotes;
  final String eyeImagePath;

  ExaminationRecord({
    required this.name,
    required this.date,
    required this.status,
    required this.avatarUrl,
    this.aiDiagnosis = '',
    this.doctorDiagnosis = '',
    this.doctorName = '',
    this.doctorNotes = '',
    this.eyeImagePath = 'assets/images/mata.png',
  });

  // Factory constructor to create an ExaminationRecord from JSON
  factory ExaminationRecord.fromJson(Map<String, dynamic> json) {
    return ExaminationRecord(
      name: json['name'],
      date: DateTime.parse(json['date']),
      status: json['status'],
      avatarUrl: json['avatarUrl'] ?? '',
      aiDiagnosis: json['aiDiagnosis'] ?? '',
      doctorDiagnosis: json['doctorDiagnosis'] ?? '',
      doctorName: json['doctorName'] ?? '',
      doctorNotes: json['doctorNotes'] ?? '',
      eyeImagePath: json['eyeImagePath'] ?? 'assets/images/mata.png',
    );
  }
}

class RiwayatController extends GetxController {
  // Tab selection
  final selectedTab = 0.obs; // 0 = On Progress, 1 = Selesai

  // Bottom navbar selection
  final selectedNavIndex = 1.obs; // 1 = Riwayat tab

  // Single data source for all examinations
  final allExaminations = <ExaminationRecord>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Load dummy data from JSON
    loadExaminationsFromJson();
  }

  // Load examinations from JSON data
  void loadExaminationsFromJson() {
    final List<Map<String, dynamic>> examinationsJson = [
      {
        'name': 'James Peter',
        'date': '2025-02-17T13:22:15',
        'status': 'On Review',
        'avatarUrl': '',
        'aiDiagnosis': 'Buta',
        'eyeImagePath': 'assets/images/mata.png'
      },
      {
        'name': 'Sarah Johnson',
        'date': '2025-02-15T10:45:30',
        'status': 'On Review',
        'avatarUrl': '',
        'aiDiagnosis': 'Katarak',
        'eyeImagePath': 'assets/images/mata.png'
      },
      {
        'name': 'Michael Smith',
        'date': '2025-02-12T09:15:00',
        'status': 'On Review',
        'avatarUrl': '',
        'aiDiagnosis': 'Glaukoma',
        'eyeImagePath': 'assets/images/mata.png'
      },
      {
        'name': 'Amanda Lee',
        'date': '2025-01-25T14:30:45',
        'status': 'Completed',
        'avatarUrl': '',
        'aiDiagnosis': 'Buta',
        'doctorDiagnosis': 'Katarak',
        'doctorName': 'Dr. Alan Smith',
        'doctorNotes': 'Banyak Minum Air putih dan istirahat yang cukup',
        'eyeImagePath': 'assets/images/mata.png'
      },
      {
        'name': 'David Wilson',
        'date': '2025-01-20T11:10:20',
        'status': 'Completed',
        'avatarUrl': '',
        'aiDiagnosis': 'Katarak',
        'doctorDiagnosis': 'Katarak',
        'doctorName': 'Dr. Maria Johnson',
        'doctorNotes': 'Hindari paparan cahaya kuat dan kontrol rutin',
        'eyeImagePath': 'assets/images/mata.png'
      },
      {
        'name': 'Jessica Brown',
        'date': '2025-01-15T16:05:55',
        'status': 'Completed',
        'avatarUrl': '',
        'aiDiagnosis': 'Glaukoma',
        'doctorDiagnosis': 'Glaukoma',
        'doctorName': 'Dr. Robert Lee',
        'doctorNotes': 'Gunakan obat tetes mata secara teratur',
        'eyeImagePath': 'assets/images/mata.png'
      }
    ];

    // Convert JSON to ExaminationRecord objects
    allExaminations.value = examinationsJson
        .map((json) => ExaminationRecord.fromJson(json))
        .toList();
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
