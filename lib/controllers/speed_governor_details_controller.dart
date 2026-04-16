import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../views/allocation_preview_view.dart';
import '../services/api_service.dart';
import '../models/speed_governor_response.dart';

class SpeedGovernorDetailsController extends GetxController {
  final serialController = TextEditingController();
  final amountController = TextEditingController();

  final ApiService _apiService = ApiService();
  final isLoading = false.obs;

  // Speed Governor search and selection
  final governorSearchController = TextEditingController();
  final governorFocusNode = FocusNode();
  final allGovernors = <SpeedGovernor>[].obs;
  final filteredGovernors = <SpeedGovernor>[].obs;
  final showGovernorResults = false.obs;
  final selectedGovernorId = RxnInt();
  final isGovernorSelected = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchGovernors();
  }

  // Status selection
  final List<String> statusOptions = ['New', 'Repaired'];
  final selectedStatus = 'New'.obs;

  @override
  void onClose() {
    serialController.dispose();
    amountController.dispose();
    governorSearchController.dispose();
    governorFocusNode.dispose();
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

  Future<void> fetchGovernors() async {
    try {
      final response = await _apiService.getSpeedGovernors();
      if (response != null && response.data?.speedGovernors != null) {
        allGovernors.assignAll(response.data!.speedGovernors!);
        filteredGovernors.assignAll(allGovernors);
      }
    } catch (e) {
      debugPrint("Error fetching governors: $e");
    }
  }

  void filterGovernors(String query) {
    if (query.isEmpty) {
      filteredGovernors.assignAll(allGovernors);
      showGovernorResults.value = false;
      return;
    }

    final results = allGovernors.where((g) => 
      g.searchString.contains(query.toLowerCase())
    ).toList();

    filteredGovernors.assignAll(results);
    showGovernorResults.value = results.isNotEmpty;
  }

  void selectGovernor(SpeedGovernor governor) {
    governorSearchController.text = governor.sgModel ?? "";
    selectedGovernorId.value = governor.id;
    isGovernorSelected.value = true;
    showGovernorResults.value = false;
    governorFocusNode.unfocus();
  }

  void onSearchFieldTap() {
    if (governorSearchController.text.isEmpty) {
      filteredGovernors.assignAll(allGovernors);
      showGovernorResults.value = allGovernors.isNotEmpty;
    } else {
      showGovernorResults.value = filteredGovernors.isNotEmpty;
    }
  }

  Future<void> onNext() async {
    if (serialController.text.isEmpty || 
        amountController.text.isEmpty || 
        selectedGovernorId.value == null) {
      Get.snackbar(
        'Error', 
        'Please fill in all required fields and select a Speed Governor',
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
        speedGovernorId: selectedGovernorId.value.toString(),
        serialNo: serialController.text,
        amount: amountController.text,
      );

      if (success) {
        // Refresh counts from backend
        await homeController.fetchAllocationCounts();

        // Clear fields for next entry
        serialController.clear();
        amountController.clear();
        governorSearchController.clear();
        selectedGovernorId.value = null;
        isGovernorSelected.value = false;

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
