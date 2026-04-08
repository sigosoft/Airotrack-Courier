import 'package:airotrack_courier/views/gps_preview_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GPSDetailsController extends GetxController {
  final serialController = TextEditingController();
  final amountController = TextEditingController();

  @override
  void onClose() {
    serialController.dispose();
    amountController.dispose();
    super.onClose();
  }

  void onPreview() {
    Get.to(() => const GpsPreviewView());
  }

  void onNext() {
    if (serialController.text.isEmpty || amountController.text.isEmpty) {
      Get.snackbar(
        'Error', 
        'Please fill in all required fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red
      );
      return;
    }
    // Navigate to success screen
    Get.to(() => const GpsPreviewView());
  }
}
