import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:IntelliSight/utils/constants/color.dart';
import 'package:IntelliSight/utils/widgets/stylish_progress_indicator.dart';
import '../controllers/riwayat_controller.dart';

class AppStyles {
  static const Color primaryBlue = primaryColor;
  static const Color backgroundBlue = Color(0xFFF0F5FF);
  static const Color cardBackground = Colors.white;
  static const Color completedGreen = Color(0xFF23A26D);
  static const Color pendingYellow = Color(0xFFFFC817);
  static const Color tabBackground = Color(0xFFF2F2F2);
  static const Color dividerColor = Color(0xFFEEEEEE);
  static const Color successGreen = Color(0xFF1DB068);
  static const Color successBackground = Color(0xFFEAF7F2);
  static const Color pendingBackground = Color(0xFFF6F6F6);
  static const Color pendingIconColor = Color(0xFFBBBBBB);
  static const Color textDark = Color(0xFF333333);
  static const Color textMedium = Color(0xFF666666);
  static const Color textLight = Color(0xFFA8A09E);

  static const double cardRadius = 16;
  static const double buttonRadius = 10;
  static const double iconSize = 24;
  static const double spacing = 16;
  static const double smallSpacing = 12;
  static const double largeSpacing = 24;

  static const TextStyle headerStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: textDark,
  );

  static const TextStyle cardTitleStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Color(0xFF1F1F1F),
  );

  static const TextStyle tabStyle = TextStyle(
    fontWeight: FontWeight.w500,
  );

  static const TextStyle detailLabelStyle = TextStyle(
    fontSize: 14,
    color: textMedium,
  );

  static const TextStyle detailValueStyle = TextStyle(
    fontSize: 14,
    color: textDark,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle detailHighlightStyle = TextStyle(
    fontSize: 14,
    color: primaryBlue,
    fontWeight: FontWeight.bold,
  );

  static const EdgeInsets defaultPadding = EdgeInsets.all(spacing);
  static const EdgeInsets smallPadding = EdgeInsets.all(smallSpacing);
}

class RiwayatView extends GetView<RiwayatController> {
  const RiwayatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundBlue,
      body: SafeArea(
        child: Padding(
          padding: AppStyles.defaultPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Examination History', style: AppStyles.headerStyle),
              SizedBox(height: AppStyles.spacing),
              _buildTabSelector(),
              SizedBox(height: AppStyles.spacing),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return Center(
                      child: StylishProgressIndicator(
                        size: 50,
                        color: Colors.blue,
                        hasGlow: true,
                      ),
                    );
                  }

                  if (controller.hasError.value) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Failed to load data',
                            style: AppStyles.cardTitleStyle,
                          ),
                          Text(
                            controller.errorMessage.value,
                            style: AppStyles.detailLabelStyle,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: controller.refreshExaminations,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppStyles.primaryBlue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (controller.filteredExaminations.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.history,
                            size: 80,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No examination records found',
                            style: AppStyles.cardTitleStyle,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            controller.selectedTab.value == 0
                                ? 'You have no ongoing examinations'
                                : 'You have no completed examinations',
                            style: AppStyles.detailLabelStyle,
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: controller.refreshExaminations,
                    child: ListView.builder(
                      itemCount: controller.filteredExaminations.length,
                      itemBuilder: (context, index) {
                        return _buildExaminationCard(
                            controller.filteredExaminations[index], context);
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ========= widget untuk memilih tab =========
  Widget _buildTabSelector() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: AppStyles.tabBackground,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Obx(() => Row(
            children: [
              _buildTabItem(0, 'On Progress'),
              _buildTabItem(1, 'Completed'),
            ],
          )),
    );
  }

  // ========= widget untuk item tab =========
  Widget _buildTabItem(int tabIndex, String title) {
    final isSelected = controller.selectedTab.value == tabIndex;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.changeTab(tabIndex),
        child: Container(
          decoration: BoxDecoration(
            color:
                isSelected ? AppStyles.cardBackground : AppStyles.tabBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: AppStyles.tabStyle.copyWith(
              color: isSelected
                  ? AppStyles.primaryBlue
                  : (tabIndex == 0 ? Colors.grey : AppStyles.textLight),
            ),
          ),
        ),
      ),
    );
  }

  // ========= widget untuk kartu pemeriksaan =========
  Widget _buildExaminationCard(
      ExaminationRecord examination, BuildContext context) {
    final isCompleted = examination.status == "Completed";

    return GestureDetector(
      onTap: () => _showExaminationDetailsPopup(context, examination),
      child: Container(
        margin: EdgeInsets.only(bottom: AppStyles.spacing),
        decoration: BoxDecoration(
          color: AppStyles.cardBackground,
          borderRadius: BorderRadius.circular(AppStyles.cardRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: AppStyles.defaultPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildAvatarWithSmile(),
                  SizedBox(width: AppStyles.smallSpacing),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(examination.patientName,
                            style: AppStyles.cardTitleStyle),
                        _buildStatusPill(isCompleted, examination.status),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppStyles.spacing),
              _buildDateInfoBox(examination),
            ],
          ),
        ),
      ),
    );
  }

  // ========= widget untuk pill status =========
  Widget _buildStatusPill(bool isCompleted, String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isCompleted ? AppStyles.completedGreen : AppStyles.pendingYellow,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            offset: const Offset(0, 4),
            blurRadius: 4,
          ),
        ],
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  // ========= widget untuk kotak info tanggal =========
  Widget _buildDateInfoBox(ExaminationRecord examination) {
    return Container(
      padding: AppStyles.smallPadding,
      decoration: BoxDecoration(
        border: Border.all(color: AppStyles.primaryBlue, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_month_outlined,
                  color: AppStyles.primaryBlue,
                  size: 24,
                ),
                SizedBox(width: 5),
                Text(
                  controller.getDayOfWeek(examination.examinationDate),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppStyles.primaryBlue,
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              children: [
                const Icon(
                  Icons.access_time_outlined,
                  color: AppStyles.primaryBlue,
                  size: 24,
                ),
                SizedBox(width: 5),
                Text(
                  controller.formatDate(examination.examinationDate),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppStyles.primaryBlue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ========= popup detail pemeriksaan =========
  void _showExaminationDetailsPopup(
      BuildContext context, ExaminationRecord examination) {
    final isCompleted = examination.status == 'Completed';
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Color(0xFFFFFFFF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Eye image
              Center(
                child: Column(
                  children: [
                    isCompleted
                        ? Stack(
                            alignment: Alignment.center,
                            children: [
                              // Lingkaran hijau tua di belakang
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Color(0xFFE4F3ED), // hijau tua
                                  shape: BoxShape.circle,
                                ),
                              ),
                              // Lingkaran hijau muda di atasnya
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Color(0xFF23A26D), // hijau muda
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.check,
                                  size: 34,
                                  color: Colors.white, // ikon putih
                                ),
                              ),
                            ],
                          )
                        : Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(
                                  255, 216, 216, 216), // background abu-abu
                              shape: BoxShape.circle, // bentuk lingkaran
                            ),
                            child: Icon(
                              Icons.timelapse_outlined,
                              size: 34,
                              color: Colors.white, // warna ikon putih
                            ),
                          ),
                    SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(
                        examination.eyeImageUrl,
                        height: 171,
                        width: 222,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 200,
                          width: 200,
                          color: Colors.grey.shade200,
                          child: const Center(
                            child: Icon(
                              Icons.broken_image,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            height: 200,
                            width: 200,
                            color: Colors.grey.shade200,
                            child: const Center(
                              child: StylishProgressIndicator(
                                size: 50,
                                color: Colors.blue,
                                hasGlow: true,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Divider(
                height: 1,
                thickness: 1,
                color: Colors.grey.shade200,
              ),
              const SizedBox(height: 24),
              // Information rows

              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      isCompleted
                          ? Text(
                              'Diagnosis by Doctor',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF707070),
                              ),
                            )
                          : Text(
                              'Early Diagnosis by AI',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF707070),
                              ),
                            ),
                      isCompleted
                          ? Expanded(
                              child: Text(
                                examination.diagnosis,
                                textAlign: TextAlign.right,
                                softWrap: true,
                                overflow: TextOverflow.visible,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: primaryColor,
                                ),
                              ),
                            )
                          : Expanded(
                              child: Text(
                                examination.diagnosis,
                                textAlign: TextAlign.right,
                                softWrap: true,
                                overflow: TextOverflow.visible,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF45B3CB),
                                ),
                              ),
                            ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Registration date',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF707070),
                        ),
                      ),
                      Text(
                        controller.formatDate(examination.examinationDate),
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF121212),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Status',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF707070),
                        ),
                      ),
                      Text(
                        examination.status,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF121212),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),
              DottedLine(
                direction: Axis.horizontal,
                lineLength: double.infinity,
                lineThickness: 1.0,
                dashLength: 6.0,
                dashColor: Color(0XFFEDEDED),
              ),
              const SizedBox(height: 16),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Doctor name',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF707070),
                        ),
                      ),
                      Text(
                        examination.doctorName ?? "-----",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF121212),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  isCompleted
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text(
                                'Doctor notes',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFFA5A5A5),
                                ),
                              ),
                              Text(
                                examination.doctorsNote!,
                                textAlign: TextAlign.center,
                                softWrap: true,
                                overflow: TextOverflow.visible,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF121212),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Doctor notes',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF707070),
                              ),
                            ),
                            Text(
                              "-----",
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF121212),
                              ),
                            ),
                          ],
                        )
                ],
              ),

              const SizedBox(height: 24),

              // Kembali button
              Center(
                child: SizedBox(
                  width: 109,
                  height: 30,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Ok'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarWithSmile({double size = 58}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: Image.asset(
          'assets/images/image.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
