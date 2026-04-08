import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../views/camera_preview_view.dart';
import '../views/allocation_success_view.dart';

class CameraDetailsController extends GetxController {
  final serialController = TextEditingController();
  final amountController = TextEditingController();

  @override
  void onClose() {
    serialController.dispose();
    amountController.dispose();
    super.onClose();
  }

  void onPreview() {
    Get.to(() => const CameraPreviewView());
  }

  void onNext() {
    // Logic for Next button
    if (serialController.text.isEmpty || amountController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill in all required fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red);
      return;
    }
    // Navigate to next screen
    Get.to(() => const AllocationSuccessView());
  }
}
