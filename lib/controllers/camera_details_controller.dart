import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../views/allocation_preview_view.dart';
import '../services/api_service.dart';
import '../controllers/home_controller.dart';

class CameraDetailsController extends GetxController {
  final serialController = TextEditingController();
  final amountController = TextEditingController();
  final cameraNameController = TextEditingController();

  final ApiService _apiService = ApiService();
  final isLoading = false.obs;


  @override
  void onClose() {
    serialController.dispose();
    amountController.dispose();
    super.onClose();
  }



  void onPreview() {
    Get.find<HomeController>().fetchAllocationCounts();
    Get.to(() => const AllocationPreviewView());
  }

  Future<void> onNext() async {
    if (serialController.text.isEmpty || amountController.text.isEmpty || cameraNameController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill in all required fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red);
      return;
    }

    isLoading.value = true;
    try {
      final HomeController homeController = Get.find<HomeController>();
      
      final success = await _apiService.postDeviceDetails(
        userType: homeController.selectedUserTypeValue.value,
        userId: homeController.selectedUserId.value,
        deviceType: 1, // Camera
        serialNo: serialController.text,
        cameraName: cameraNameController.text,
        amount: amountController.text,
      );

      if (success) {
        // Refresh counts from backend
        await homeController.fetchAllocationCounts();

        // Clear fields for next entry
        serialController.clear();
        amountController.clear();
        cameraNameController.clear();

        // Navigate to unified AllocationPreviewView
        Get.to(() => const AllocationPreviewView());
      } else {
        Get.snackbar('Error', 'Failed to store camera details. Please try again.',
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
