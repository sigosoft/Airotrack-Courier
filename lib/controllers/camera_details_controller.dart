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
    cameraNameController.dispose();
    super.onClose();
  }

  void onPreview() {
    final homeController = Get.find<HomeController>();
    final req = homeController.selectedCourierRequest.value;
    if (req != null) {
      final int allowed =
          (req.noOfNewCameras ?? 0) + (req.noOfServiceCameras ?? 0);
      final int entered =
          homeController.newCameraCount.value +
          homeController.repairedCameraCount.value;
      if (entered != allowed) {
        Get.snackbar(
          "Validation Error",
          "Please enter the exact count of Cameras required ($allowed devices). Current count: $entered.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
    }
    homeController.fetchAllocationCounts();
    Get.to(() => const AllocationPreviewView());
  }

  /// Returns true when the entered camera count has reached the allowed limit.
  bool get isCameraLimitReached {
    final homeController = Get.find<HomeController>();
    final req = homeController.selectedCourierRequest.value;
    if (req == null) return false;
    final int allowed =
        (req.noOfNewCameras ?? 0) + (req.noOfServiceCameras ?? 0);
    final int entered =
        homeController.newCameraCount.value +
        homeController.repairedCameraCount.value;
    return allowed > 0 && entered >= allowed;
  }

  Future<void> onNext() async {
    if (serialController.text.isEmpty || cameraNameController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all required fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final HomeController homeController = Get.find<HomeController>();
    if (homeController.selectedCourierRequest.value != null) {
      final req = homeController.selectedCourierRequest.value!;
      final int allowedCameraCount =
          (req.noOfNewCameras ?? 0) + (req.noOfServiceCameras ?? 0);
      final int enteredCameraCount =
          homeController.newCameraCount.value +
          homeController.repairedCameraCount.value;
      if (enteredCameraCount >= allowedCameraCount) {
        Get.snackbar(
          'Error',
          'You have already entered the maximum allowed number of cameras ($allowedCameraCount).',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
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
        amount: "0",
      );

      if (success) {
        // Refresh counts from backend
        await homeController.fetchAllocationCounts();

        // Clear fields for next entry
        serialController.clear();
        amountController.clear();
        cameraNameController.clear();

        // Check if limit is now reached — navigate to preview
        final req = homeController.selectedCourierRequest.value;
        if (req != null) {
          final int allowedCameraCount =
              (req.noOfNewCameras ?? 0) + (req.noOfServiceCameras ?? 0);
          final int enteredCameraCount =
              homeController.newCameraCount.value +
              homeController.repairedCameraCount.value;
          if (enteredCameraCount >= allowedCameraCount) {
            Get.to(() => const AllocationPreviewView());
            return;
          }
          // Count not yet reached — stay on the same screen for next entry
        } else {
          // No courier request limit set (without request case) — stay on the same page to enter next data
          Get.snackbar(
            'Success',
            'Camera details stored successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'Error',
          'Failed to store camera details. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint("Error in onNext: $e");
      Get.snackbar(
        'Error',
        'An unexpected error occurred.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
