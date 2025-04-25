import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/riwayat_controller.dart';

class AppStyles {
  static const Color primaryBlue = Color(0xFF146EF5);
  static const Color backgroundBlue = Color(0xFFF0F5FF);
  static const Color cardBackground = Colors.white;
  static const Color textDark = Color(0xFF333333);
  static const Color textMedium = Color(0xFF666666);
  static const Color textLight = Color(0xFFA8A09E);
  static const Color completedGreen = Color(0xFF23A26D);
  static const Color pendingYellow = Color(0xFFFFC817);
  static const Color tabBackground = Color(0xFFF2F2F2);
  static const Color dividerColor = Color(0xFFEEEEEE);
  static const Color successGreen = Color(0xFF1DB068);
  static const Color successBackground = Color(0xFFEAF7F2);
  static const Color pendingBackground = Color(0xFFF6F6F6);
  static const Color pendingIconColor = Color(0xFFBBBBBB);

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
              // Header
              Text('Riwayat Pemeriksaan', style: AppStyles.headerStyle),
              SizedBox(height: AppStyles.spacing),

              // Tab selector
              _buildTabSelector(),
              SizedBox(height: AppStyles.spacing),

              // Examination history cards
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(),
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

  // Tab selector widget
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
              _buildTabItem(1, 'Selesai'),
            ],
          )),
    );
  }

  // Individual tab item
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

  // Examination card
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
              // User info and status row
              Row(
                children: [
                  _buildAvatarWithSmile(),
                  SizedBox(width: AppStyles.smallSpacing),

                  // Name and status
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

              // Date info
              _buildDateInfoBox(examination),
            ],
          ),
        ),
      ),
    );
  }

  // Status pill widget
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

  // Date info box
  Widget _buildDateInfoBox(ExaminationRecord examination) {
    return Container(
      padding: AppStyles.smallPadding,
      decoration: BoxDecoration(
        color: AppStyles.backgroundBlue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.calendar_today_outlined,
            color: AppStyles.primaryBlue,
            size: 20,
          ),
          SizedBox(width: AppStyles.smallSpacing),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.getDayOfWeek(examination.examinationDate),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppStyles.textMedium,
                ),
              ),
              Text(
                controller.formatDate(examination.examinationDate),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppStyles.textDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Examination details popup
  void _showExaminationDetailsPopup(
      BuildContext context, ExaminationRecord examination) {
    final isCompleted = examination.status == "Completed";

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Examination Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Patient name and status
            Row(
              children: [
                _buildAvatarWithSmile(size: 50),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        examination.patientName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? AppStyles.completedGreen.withOpacity(0.1)
                              : AppStyles.pendingYellow.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          examination.status,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isCompleted
                                ? AppStyles.completedGreen
                                : AppStyles.pendingYellow,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Divider
            Container(
              height: 1,
              color: Colors.grey.shade200,
            ),
            const SizedBox(height: 16),

            // Date
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  color: AppStyles.primaryBlue,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  '${controller.getDayOfWeek(examination.examinationDate)}, ${controller.formatDate(examination.examinationDate)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Eye scan image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                examination.eyeImageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 200,
                  width: double.infinity,
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
                    width: double.infinity,
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // AI Diagnosis
            const Text(
              'AI Diagnosis',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              ),
              child: Text(
                examination.diagnosis,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppStyles.textDark,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Complaints (if any)
            if (examination.complaints != null &&
                examination.complaints!.isNotEmpty) ...[
              const Text(
                'Patient Complaints',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey.shade200,
                    width: 1,
                  ),
                ),
                child: Text(
                  examination.complaints!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppStyles.textDark,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Doctor's diagnosis and notes (if status is completed)
            if (examination.status == "Completed") ...[
              const Text(
                'Doctor\'s Diagnosis',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey.shade200,
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.person,
                          size: 16,
                          color: AppStyles.primaryBlue,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          examination.doctorName ?? 'Unknown Doctor',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppStyles.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (examination.doctorsNote != null &&
                        examination.doctorsNote!.isNotEmpty)
                      Text(
                        examination.doctorsNote!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppStyles.textDark,
                        ),
                      )
                    else
                      const Text(
                        'No additional notes from doctor',
                        style: TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          color: AppStyles.textLight,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ],
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
        border: Border.all(
          color: Colors.orange,
          width: 3,
        ),
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
