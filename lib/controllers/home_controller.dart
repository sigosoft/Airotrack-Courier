import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';
import '../models/user_profile.dart';
import '../services/api_service.dart';
import '../models/dealers_response.dart';
import '../models/technicians_response.dart';

class HomeController extends GetxController {
  // Observable user profile state
  final userProfile = UserProfile(
    name: 'Jobin',
    date: '05 Jun 2023',
    time: '08:22:11 AM',
    userTypeOptions: ['Dealer', 'Technician'],
    selectedUserType: 'Select User Type',
  ).obs;

  final ApiService _apiService = ApiService();
  final RxList<Dealer> fetchedDealers = <Dealer>[].obs;
  final RxList<Technician> fetchedTechnicians = <Technician>[].obs;
  final RxBool isDealersLoading = false.obs;
  final RxBool isTechniciansLoading = false.obs;

  // Method to update user type
  void updateSelectedUserType(String? value) {
    if (value != null) {
      userProfile.update((val) {
        val?.selectedUserType = value;
      });

      if (value == 'Dealer') {
        fetchDealers();
      } else if (value == 'Technician') {
        fetchTechnicians();
      }

      // Reset dealer search if user type changes
      selectedDealerName.value = '';
      selectedDeviceType.value = '';
    }
  }

  Future<void> fetchDealers({String keyword = ""}) async {
    isDealersLoading.value = true;
    try {
      final response = await _apiService.getDealers(keyword: keyword);
      if (response != null && response.status == "true") {
        fetchedDealers.value = response.data?.dealers ?? [];
      } else {
        Get.snackbar(
          "Error",
          response?.message ?? "Failed to fetch dealers",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.7),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      _handleApiError(e);
    } finally {
      isDealersLoading.value = false;
    }
  }

  Future<void> fetchTechnicians({String keyword = ""}) async {
    isTechniciansLoading.value = true;
    try {
      final response = await _apiService.getTechnicians(keyword: keyword);
      if (response != null && response.status == "true") {
        fetchedTechnicians.value = response.data?.technicians ?? [];
      } else {
        Get.snackbar(
          "Error",
          response?.message ?? "Failed to fetch technicians",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.7),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      _handleApiError(e);
    } finally {
      isTechniciansLoading.value = false;
    }
  }

  void _handleApiError(dynamic e) {
    String errorMessage = "Something went wrong. Please try again later.";
    if (e is DioException) {
      var data = e.response?.data;
      if (data != null && data is Map && data['message'] != null) {
        var msg = data['message'];
        if (msg is String) {
          errorMessage = msg;
        } else if (msg is Map && msg.isNotEmpty) {
          var firstError = msg.values.first;
          errorMessage = (firstError is List && firstError.isNotEmpty)
              ? firstError.first.toString()
              : firstError.toString();
        } else {
          errorMessage = msg.toString();
        }
      } else {
        errorMessage = e.message ?? errorMessage;
      }
    }
    Get.snackbar(
      "Error",
      errorMessage,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.7),
      colorText: Colors.white,
    );
  }

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
      if (userProfile.value.selectedUserType == 'Dealer') {
        final results = fetchedDealers
            .where(
              (d) => (d.firstName ?? '').toLowerCase().contains(
                query.toLowerCase(),
              ),
            )
            .map((d) => d.firstName ?? '')
            .toList();
        filteredResults.value = results;
      } else if (userProfile.value.selectedUserType == 'Technician') {
        final results = fetchedTechnicians
            .where(
              (t) => (t.name ?? '').toLowerCase().contains(query.toLowerCase()),
            )
            .map((t) => t.name ?? '')
            .toList();
        filteredResults.value = results;
      }

      showResults.value = filteredResults.isNotEmpty;

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
  void onInit() {
    super.onInit();
    loadUserData();
  }

  void loadUserData() {
    var box = Hive.box('userBox');
    String? userDataString = box.get('userData');
    if (userDataString != null) {
      try {
        Map<String, dynamic> data = jsonDecode(userDataString);
        userProfile.update((val) {
          val?.name = data['name'] ?? 'Guest';

          // Parsing "14 Aug 2025, 06:28 am"
          String fullDate = data['converted_created_at']?.toString() ?? "";
          if (fullDate.contains(',')) {
            List<String> parts = fullDate.split(',');
            val?.date = parts[0].trim();
            val?.time = parts[1].trim();
          }
        });
      } catch (e) {
        debugPrint("Error loading user data: $e");
      }
    }
  }

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

  // Computed total devices
  int get totalDevicesCount =>
      newCameraCount.value +
      repairedCameraCount.value +
      newSpeedGovernorCount.value +
      repairedSpeedGovernorCount.value;

  // Method to clear all counts
  void clearDeviceCounts() {
    newCameraCount.value = 0;
    repairedCameraCount.value = 0;
    newSpeedGovernorCount.value = 0;
    repairedSpeedGovernorCount.value = 0;
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
