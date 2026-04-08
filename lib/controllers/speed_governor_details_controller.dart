import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../views/speed_governor_preview_view.dart';

class SpeedGovernorDetailsController extends GetxController {
  final serialController = TextEditingController();
  final amountController = TextEditingController();

  @override
  void onClose() {
    serialController.dispose();
    amountController.dispose();
    super.onClose();
  }

  void onPreview() {
    Get.to(() => const SpeedGovernorPreviewView());
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
    Get.to(() => const SpeedGovernorPreviewView());
  }
}
