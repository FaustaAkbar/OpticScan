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
                child: Obx(() => ListView.builder(
                      itemCount: controller.filteredExaminations.length,
                      itemBuilder: (context, index) {
                        return _buildExaminationCard(
                            controller.filteredExaminations[index], context);
                      },
                    )),
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
                        Text(examination.name, style: AppStyles.cardTitleStyle),
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
      decoration: BoxDecoration(
        border: Border.all(color: AppStyles.primaryBlue),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildDateItem(Icons.calendar_today,
                controller.getDayOfWeek(examination.date)),
            _buildDateItem(
                Icons.access_time, controller.formatDate(examination.date)),
          ],
        ),
      ),
    );
  }

  // Date item with icon
  Widget _buildDateItem(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: AppStyles.primaryBlue,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: AppStyles.primaryBlue,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // Examination details popup
  void _showExaminationDetailsPopup(
      BuildContext context, ExaminationRecord examination) {
    final isCompleted = examination.status == "Completed";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            decoration: BoxDecoration(
              color: AppStyles.cardBackground,
              borderRadius: BorderRadius.circular(20),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Status icon
                    isCompleted ? _buildCompletedIcon() : _buildPendingIcon(),
                    SizedBox(height: AppStyles.spacing),

                    // Eye image
                    _buildEyeImage(examination.eyeImagePath),
                    const SizedBox(height: 25),

                    // Divider
                    Divider(
                        color: AppStyles.dividerColor, thickness: 1, height: 1),
                    const SizedBox(height: 25),

                    // Diagnosis information
                    isCompleted
                        ? _buildDiagnosisRow(
                            'Diagnosis by Doctor', examination.doctorDiagnosis)
                        : _buildDiagnosisRow(
                            'Early Diagnosis by AI', examination.aiDiagnosis),
                    SizedBox(height: AppStyles.smallSpacing),

                    // Information rows
                    _buildInfoRow('Tanggal Registrasi',
                        _formatDateTime(examination.date)),
                    SizedBox(height: AppStyles.smallSpacing),

                    _buildInfoRow(
                      'Status',
                      isCompleted ? 'completed' : 'On going',
                      valueColor: isCompleted
                          ? AppStyles.completedGreen
                          : AppStyles.pendingYellow,
                    ),
                    SizedBox(height: AppStyles.smallSpacing),

                    // Dashed divider
                    CustomPaint(
                      size: const Size(double.infinity, 1),
                      painter: DashedLinePainter(),
                    ),
                    SizedBox(height: AppStyles.smallSpacing),

                    // Doctor information
                    _buildInfoRow('Nama Dokter',
                        isCompleted ? examination.doctorName : '-----'),
                    SizedBox(height: AppStyles.smallSpacing),

                    // Doctor notes
                    isCompleted
                        ? _buildCenteredDoctorNotes(examination.doctorNotes)
                        : _buildInfoRow('Catatan dokter', '-----'),

                    SizedBox(height: AppStyles.largeSpacing),

                    // Back button
                    _buildBackButton(context),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Completed status icon
  Widget _buildCompletedIcon() {
    return Container(
      width: 60,
      height: 60,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppStyles.successBackground,
      ),
      alignment: Alignment.center,
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppStyles.successGreen,
        ),
        alignment: Alignment.center,
        child: const Icon(
          Icons.check,
          color: Colors.white,
          size: AppStyles.iconSize,
        ),
      ),
    );
  }

  // Pending status icon
  Widget _buildPendingIcon() {
    return Container(
      width: 60,
      height: 60,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppStyles.pendingBackground,
      ),
      alignment: Alignment.center,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: const Icon(
          Icons.schedule,
          color: AppStyles.pendingIconColor,
          size: AppStyles.iconSize,
        ),
      ),
    );
  }

  // Eye image
  Widget _buildEyeImage(String imagePath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Image.asset(
        imagePath,
        width: 222,
        height: 172,
        fit: BoxFit.cover,
      ),
    );
  }

  // Diagnosis row with highlight
  Widget _buildDiagnosisRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppStyles.detailLabelStyle),
        Text(value, style: AppStyles.detailHighlightStyle),
      ],
    );
  }

  // Information row
  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppStyles.detailLabelStyle),
        Flexible(
          child: Text(
            value,
            style: AppStyles.detailValueStyle.copyWith(
              color: valueColor ?? AppStyles.textDark,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // Centered doctor notes for completed status
  Widget _buildCenteredDoctorNotes(String notes) {
    return Column(
      children: [
        const SizedBox(height: 4),
        Text(
          'Catatan dokter',
          style: AppStyles.detailLabelStyle.copyWith(
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          notes,
          style: AppStyles.detailValueStyle,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // Back button
  Widget _buildBackButton(BuildContext context) {
    return SizedBox(
      width: 150,
      child: ElevatedButton(
        onPressed: () => Navigator.of(context).pop(),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppStyles.primaryBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppStyles.buttonRadius),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: const Text(
          'Kembali',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime date) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy, HH:mm:ss');
    return formatter.format(date);
  }

  Widget _buildAvatarWithSmile() {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.orange,
          width: 3,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Image.asset(
          'assets/images/image.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

// Painter for drawing dashed lines
class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 5, dashSpace = 3, startX = 0;
    final paint = Paint()
      ..color = AppStyles.dividerColor
      ..strokeWidth = 1;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
