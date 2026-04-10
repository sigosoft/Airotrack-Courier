import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/user_profile.dart';

class HomeController extends GetxController {
  // Observable user profile state
  final userProfile = UserProfile(
    name: 'Jobin',
    date: '05 Jun 2023',
    time: '08:22:11 AM',
    userTypeOptions: ['Dealer', 'Technician'],
    selectedUserType: 'Select User Type',
  ).obs;

  // Method to update user type
  void updateSelectedUserType(String? value) {
    if (value != null) {
      userProfile.update((val) {
        val?.selectedUserType = value;
      });
      // Reset dealer search if user type changes
      selectedDealerName.value = '';
      selectedDeviceType.value = '';
    }
  }

  // Dummy dealers and technicians for simulation
  final List<String> dealerList = [
    'Dealer 1',
    'Dealer 2',
    'Dealer 3',
    'Dealer 4',
  ];
  final List<String> technicianList = ['Tech 1', 'Tech 2', 'Tech 3'];

  // Observable list for search results
  final filteredResults = <String>[].obs;

  // Observable to show/hide results list
  final showResults = false.obs;

  // Observable to track if a selection has been made
  final isDealerSelected = false.obs;

  // Observable for selected dealer name
  final selectedDealerName = ''.obs;

  // Observable for selected device type
  final selectedDeviceType = ''.obs;

  // Device types list
  final List<String> deviceTypeOptions = ['GPS', 'Camera', 'Speed Governor'];

  // Method to filter results as user types
  void filterResults(String query) {
    if (query.isEmpty) {
      filteredResults.clear();
      showResults.value = false;
      isDealerSelected.value = false;
      selectedDealerName.value = '';
    } else {
      final List<String> source =
          userProfile.value.selectedUserType == 'Dealer'
              ? dealerList
              : technicianList;

      final results = source
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
      filteredResults.value = results;
      showResults.value = results.isNotEmpty;

      // If text changed after selection, reset selection
      if (selectedDealerName.value != query) {
        isDealerSelected.value = false;
      }
    }
  }

  // Controller for the search text field
  final searchController = TextEditingController();

  // FocusNode for the search field
  final searchFocusNode = FocusNode();


  @override
  void onClose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.onClose();
  }

  // Method to finalize selection
  void selectDealer(String name) {
    selectedDealerName.value = name;
    searchController.text = name; // Update the UI field
    isDealerSelected.value = true;
    showResults.value = false;
    filteredResults.clear();
    searchFocusNode.unfocus(); // Close keyboard on selection
  }

  // Device counts for Allocation Summary
  final newCameraCount = 0.obs;
  final repairedCameraCount = 0.obs;
  final newSpeedGovernorCount = 0.obs;
  final repairedSpeedGovernorCount = 0.obs;
  final newGpsCount = 0.obs;
  final repairedGpsCount = 0.obs;

  // Computed total devices
  int get totalDevicesCount =>
      newCameraCount.value +
      repairedCameraCount.value +
      newSpeedGovernorCount.value +
      repairedSpeedGovernorCount.value +
      newGpsCount.value +
      repairedGpsCount.value;

  // Method to clear all counts
  void clearDeviceCounts() {
    newCameraCount.value = 0;
    repairedCameraCount.value = 0;
    newSpeedGovernorCount.value = 0;
    repairedSpeedGovernorCount.value = 0;
    newGpsCount.value = 0;
    repairedGpsCount.value = 0;
  }


  // Reset UI fields but KEEP device counts
  void resetAll() {
    selectedDealerName.value = '';
    selectedDeviceType.value = '';
    searchController.clear();
    isDealerSelected.value = false;
    showResults.value = false;
    filteredResults.clear();
    userProfile.update((val) {
      val?.selectedUserType = 'Select User Type';
    });
  }

  // Method to update device type
  void updateDeviceType(String value) {
    selectedDeviceType.value = value;
  }
}
