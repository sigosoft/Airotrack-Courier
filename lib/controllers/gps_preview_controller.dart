import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../services/api_service.dart';
import '../controllers/home_controller.dart';
import '../views/allocation_success_view.dart';
import '../views/home_view.dart';

class GpsPreviewController extends GetxController {
  final ApiService _apiService = ApiService();

  final isLoading = true.obs;
  final isActionLoading = false.obs;
  final totalDevices = "0".obs;
  final newDevices = "0".obs;
  final repairedDevices = "0".obs;

  // Store the list of devices.
  // Map can hold {"imei": "123", "dealer": "Dealer 2"}
  final RxList<Map<String, String>> deviceList = <Map<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPreviewData();
  }

  Future<void> fetchPreviewData() async {
    isLoading.value = true;
    try {
      if (!Hive.isBoxOpen('userBox')) {
        await Hive.openBox('userBox');
      }
      var box = Hive.box('userBox');
      String? userDataString = box.get('userData');
      String userId = "";
      String userType = "2";

      if (userDataString != null) {
        try {
          Map<String, dynamic> data = jsonDecode(userDataString);
          userId = data['id']?.toString() ?? "";
          userType = data['role_id']?.toString() ?? "2";
        } catch (e) {
          debugPrint("Error reading user data: $e");
        }
      }

      final response = await _apiService.getGpsPreview(
        userType: "2",
        userId: userId,
      );

      // Status could be boolean or string 'true' based on response
      bool isSuccess =
          response != null &&
          (response['status'] == true || response['status'] == "true");

      if (isSuccess && response['data'] != null) {
        final data = response['data'];
        totalDevices.value = data['total_imei_count']?.toString() ?? "0";
        newDevices.value = data['new_devices_count']?.toString() ?? "0";
        repairedDevices.value =
            data['total_repaired_devices_count']?.toString() ?? "0";

        // Parse device data array
        List<Map<String, String>> parsedList = [];
        if (data['device_data'] != null && data['device_data'] is List) {
          for (var item in data['device_data']) {
            String imei = item['imei']?.toString() ?? "Unknown";
            String? dealerName;
            if (item['vehicle_device_data'] != null &&
                item['vehicle_device_data'] is Map) {
              // If it already has a dealer name
              dealerName =
                  item['vehicle_device_data']['dealer_name']?.toString() ??
                  item['vehicle_device_data']['user_name']?.toString();
            }

            // Fallback to currently selected dealer if not found in vehicle_device_data
            if (dealerName == null || dealerName.isEmpty) {
              final HomeController homeController = Get.find<HomeController>();
              dealerName = homeController.selectedDealerName.value;
              if (dealerName.isEmpty) dealerName = "Dealer";
            }

            parsedList.add({"imei": imei, "dealer": dealerName});
          }
        } else if (data['imeis'] != null && data['imeis'] is List) {
          for (var imei in data['imeis']) {
            final HomeController homeController = Get.find<HomeController>();
            var dealerName = homeController.selectedDealerName.value;
            if (dealerName.isEmpty) dealerName = "Dealer";
            parsedList.add({"imei": imei.toString(), "dealer": dealerName});
          }
        }
        deviceList.value = parsedList;
      } else {
        Get.snackbar(
          "Error",
          response?['message'] ?? "Failed to fetch preview data",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      debugPrint("API Error: $e");
      Get.snackbar(
        "Error",
        "Error fetching preview data",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> allocateDevices() async {
    isActionLoading.value = true;
    try {
      if (!Hive.isBoxOpen('userBox')) {
        await Hive.openBox('userBox');
      }
      var box = Hive.box('userBox');
      String? userDataString = box.get('userData');
      String userId = "";
      String userType = "2";

      if (userDataString != null) {
        try {
          Map<String, dynamic> data = jsonDecode(userDataString);
          userId = data['id']?.toString() ?? "";
          userType = data['role_id']?.toString() ?? "2";
        } catch (e) {}
      }

      final response = await _apiService.gpsAllocate(
        userType: "2",
        userId: userId,
        reallocate: "0",
      );

      bool isSuccess =
          response != null &&
          (response['status'] == true || response['status'] == "true");
      if (isSuccess) {
        Get.snackbar(
          "Success",
          response['message'] ?? "Device allocated successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offAll(() => AllocationSuccessScreen());
      } else {
        Get.snackbar(
          "Error",
          response?['message'] ?? "Allocation failed",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Allocation failed: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isActionLoading.value = false;
    }
  }

  Future<void> deleteTemporaryStorage() async {
    isActionLoading.value = true;
    try {
      final response = await _apiService.deleteTemporaryStorage();

      bool isSuccess =
          response != null &&
          (response['status'] == true || response['status'] == "true");
      if (isSuccess) {
        Get.snackbar(
          "Success",
          response['message'] ?? "Temporary storage deleted",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offAll(() => const HomeView()); // Navigate to home
      } else {
        Get.snackbar(
          "Error",
          response?['message'] ?? "Deletion failed",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Deletion failed: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isActionLoading.value = false;
    }
  }
}
