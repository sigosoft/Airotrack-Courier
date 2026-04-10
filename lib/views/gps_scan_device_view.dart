// ignore_for_file: deprecated_member_use

import 'package:airotrack_courier/views/gps_preview_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../controllers/scan_device_controller.dart';
import '../utils/app_colors.dart';

class GpsScanDeviceView extends GetView<ScanDeviceController> {
  const GpsScanDeviceView({super.key});
  @override
  Widget build(BuildContext context) {
    // Initializing the controller if not already done
    if (!Get.isRegistered<ScanDeviceController>()) {
      Get.lazyPut(() => ScanDeviceController());
    }

    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar with Close Icon
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(
                  left: width * 0.05,
                  top: height * 0.02,
                ),
                child: IconButton(
                  onPressed: () => controller.goBack(),
                  icon: const Icon(
                    Icons.close,
                    size: 32,
                    color: AppColors.black,
                  ),
                ),
              ),
            ),

            const Spacer(),

            // Scanner Container
            Center(
              child: Container(
                width: width * 0.9,
                height: height * 0.55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Stack(
                    children: [
                      // Camera Preview
                      MobileScanner(
                        controller: controller.cameraController,
                        onDetect: (capture) => controller.onDetect(capture),
                      ),

                      // Corner Brackets Overlay
                      CustomPaint(
                        size: Size(width * 0.9, height * 0.55),
                        painter: ScannerCornerPainter(),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const Spacer(),

            // Bottom Action Buttons
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.05,
                vertical: height * 0.05,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Flash Button
                  _buildActionButton(
                    icon: Icons.flashlight_on_outlined,
                    label: 'Flash',
                    onPressed: () => controller.toggleFlash(),
                    width: width * 0.42,
                  ),
                  // Preview Button
                  _buildActionButton(
                    icon: Icons.visibility_outlined,
                    label: 'Preview',
                    onPressed: () {
                    Navigator.push(context,MaterialPageRoute(builder:(context)=>GpsPreviewView()));
                    },
                    width: width * 0.42,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required double width,
  }) {
    return Container(
      width: width,
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.primaryBlue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.white, size: 24),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom Painter for corner brackets
class ScannerCornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = AppColors.black
          ..strokeWidth = 4
          ..style = PaintingStyle.stroke;

    const cornerLength = 40.0;
    const padding = 15.0;

    // Top Left
    canvas.drawLine(
      const Offset(padding, padding + cornerLength),
      const Offset(padding, padding),
      paint,
    );
    canvas.drawLine(
      const Offset(padding, padding),
      const Offset(padding + cornerLength, padding),
      paint,
    );

    // Top Right
    canvas.drawLine(
      Offset(size.width - padding - cornerLength, padding),
      Offset(size.width - padding, padding),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - padding, padding),
      Offset(size.width - padding, padding + cornerLength),
      paint,
    );

    // Bottom Left
    canvas.drawLine(
      Offset(padding, size.height - padding - cornerLength),
      Offset(padding, size.height - padding),
      paint,
    );
    canvas.drawLine(
      Offset(padding, size.height - padding),
      Offset(padding + cornerLength, size.height - padding),
      paint,
    );

    // Bottom Right
    canvas.drawLine(
      Offset(size.width - padding - cornerLength, size.height - padding),
      Offset(size.width - padding, size.height - padding),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - padding, size.height - padding),
      Offset(size.width - padding, size.height - padding - cornerLength),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
