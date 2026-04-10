import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../views/allocation_preview_view.dart';

class CameraDetailsController extends GetxController {
  final serialController = TextEditingController();
  final amountController = TextEditingController();

  // Status selection
  final List<String> statusOptions = ['New', 'Repaired'];
  final selectedStatus = 'New'.obs;

  @override
  void onClose() {
    serialController.dispose();
    amountController.dispose();
    super.onClose();
  }

  void updateStatus(String? value) {
    if (value != null) {
      selectedStatus.value = value;
    }
  }

  void onPreview() {
    Get.to(() => const AllocationPreviewView());
  }

  void onNext() {
    if (serialController.text.isEmpty || amountController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill in all required fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red);
      return;
    }

    // Increment counts in HomeController
    final homeController = Get.find<HomeController>();
    if (selectedStatus.value == 'New') {
      homeController.newCameraCount.value++;
    } else {
      homeController.repairedCameraCount.value++;
    }

    // Clear fields for next entry
    serialController.clear();
    amountController.clear();

    // Navigate to unified AllocationPreviewView
    Get.to(() => const AllocationPreviewView());
  }
}
