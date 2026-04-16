import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../views/allocation_preview_view.dart';
import '../services/api_service.dart';

class SpeedGovernorDetailsController extends GetxController {
  final serialController = TextEditingController();
  final amountController = TextEditingController();

  final ApiService _apiService = ApiService();
  final isLoading = false.obs;

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

  Future<void> onNext() async {
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

    isLoading.value = true;
    try {
      final homeController = Get.find<HomeController>();
      
      final success = await _apiService.postDeviceDetails(
        userType: homeController.selectedUserTypeValue.value,
        userId: homeController.selectedUserId.value,
        deviceType: 2, // Speed Governor
        speedGovernorId: serialController.text,
        amount: amountController.text,
      );

      if (success) {
        // Refresh counts from backend
        await homeController.fetchAllocationCounts();

        // Clear fields for next entry
        serialController.clear();
        amountController.clear();

        // Navigate to unified AllocationPreviewView
        Get.to(() => const AllocationPreviewView());
      } else {
        Get.snackbar('Error', 'Failed to store speed governor details.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red);
      }
    } catch (e) {
      debugPrint("Error in onNext: $e");
      Get.snackbar('Error', 'An unexpected error occurred.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }
}
