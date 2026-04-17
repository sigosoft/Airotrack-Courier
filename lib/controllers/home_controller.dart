import 'package:airotrack_courier/models/settings_model.dart';
import 'package:airotrack_courier/services/dio_client.dart';
import 'package:airotrack_courier/views/home_view.dart';
import 'package:airotrack_courier/views/need_an_update.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:io';
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

  int versionToCode(String version) {
    final parts = version.split('.');
    final major = int.parse(parts[0]);
    final minor = int.parse(parts[1]);
    final patch = int.parse(parts[2]);

    return major * 10000 + minor * 100 + patch;
  }

  void getHome() {
    debugPrint("App is up to date and in allowed state. Welcome to Home!");
  }

  void showToast(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> settings(BuildContext context) async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String buildNumber = packageInfo.version;
      final response = await DioClient().get(ApiEndPoints.settings);
      SettingsModel model = SettingsModel.fromJson(response.data);
      if (model.status == true) {
        if (Platform.isAndroid &&
            model.data?.settings?[0].maintenanceAndroid.toString() == "1") {
          Get.offAll(
            Maintenance(
              serverDownReason: model
                  .data
                  ?.settings?[0]
                  .maintenanceReasonAndroid
                  .toString(),
            ),
          );
        } else if (Platform.isIOS &&
            model.data?.settings?[0].maintenanceIos.toString() == "1") {
          Get.offAll(
            Maintenance(
              serverDownReason: model.data?.settings?[0].maintenanceReasonIos
                  .toString(),
            ),
          );
        } else if (Platform.isAndroid &&
            (model.data?.settings?[0].playStoreUpdate.toString() == "1" &&
                versionToCode(
                      model.data?.settings?[0].playStoreVersion.toString() ??
                          "",
                    ) >
                    versionToCode(buildNumber.toString()))) {
          Get.offAll(() => NeedAnUpdate());
        } else if (Platform.isIOS &&
            (model.data?.settings?[0].appStoreUpdate.toString() == "1" &&
                versionToCode(
                      model.data?.settings?[0].appStoreVersion.toString() ?? "",
                    ) >
                    versionToCode(buildNumber.toString()))) {
          Get.offAll(() => NeedAnUpdate());
        } else {
          getHome();
        }
      }
    } catch (error) {
      print("maintenance Error: $error");
      showToast(context, error.toString());
    }
  }

  // Method to update user type
  void updateSelectedUserType(String? value) {
    if (value != null) {
      userProfile.update((val) {
        val?.selectedUserType = value;
      });

      if (value == 'Dealer') {
        selectedUserTypeValue.value = 1;
        fetchDealers();
      } else if (value == 'Technician') {
        selectedUserTypeValue.value = 2;
        fetchTechnicians();
      }

      // Reset dealer search if user type changes
      selectedDealerName.value = '';
      selectedUserId.value = 0;
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

  // Observable for selected user ID (Dealer ID or Technician ID)
  final selectedUserId = 0.obs;

  // Observable for selected user type value (1 for Dealer, 2 for Technician)
  final selectedUserTypeValue = 1.obs;

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

    // Find and store the ID
    if (userProfile.value.selectedUserType == 'Dealer') {
      final dealer = fetchedDealers.firstWhere(
        (d) => d.firstName == name,
        orElse: () => Dealer(dealerId: 0),
      );
      selectedUserId.value = dealer.dealerId ?? 0;
    } else if (userProfile.value.selectedUserType == 'Technician') {
      final tech = fetchedTechnicians.firstWhere(
        (t) => t.name == name,
        orElse: () => Technician(id: 0),
      );
      selectedUserId.value = tech.id ?? 0;
    }

    // NEW: Fetch existing allocation counts for the selected user immediately
    if (selectedUserId.value != 0) {
      fetchAllocationCounts();
    }
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

  // Method to fetch allocation counts from backend
  Future<void> fetchAllocationCounts() async {
    if (selectedUserId.value == 0) return;

    try {
      final response = await _apiService.getAllocationPreview(
        userId: selectedUserId.value,
        userType: selectedUserTypeValue.value,
      );

      if (response != null && response.status == true) {
        newCameraCount.value = response.data?.newCameraDevicesCount ?? 0;
        repairedCameraCount.value = response.data?.repairedCameraDevicesCount ?? 0;
        newSpeedGovernorCount.value = response.data?.newSpeedGovernorDevicesCount ?? 0;
        repairedSpeedGovernorCount.value = response.data?.repairedSpeedGovernorDevicesCount ?? 0;
      }
    } catch (e) {
      debugPrint("Error fetching allocation counts: $e");
    }
  }

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
