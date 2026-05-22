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
  final othersRepairedDevices = "0".obs;

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
      final HomeController homeController = Get.find<HomeController>();
      String userId = homeController.selectedUserId.value.toString();
      String userType = homeController.selectedUserTypeValue.value.toString();

      final req = homeController.selectedCourierRequest.value;
      if (req != null && (userType == "3" || userType == "11")) {
        if (req.dealerId != null && req.dealerId != 0) {
          userType = "1";
          userId = req.dealerId.toString();
        } else if (req.technicianId != null && req.technicianId != 0) {
          userType = "2";
          userId = req.technicianId.toString();
        }
      }

      final response = await _apiService.getGpsPreview(
        userType: userType,
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
        othersRepairedDevices.value =
            data['others_repaired_devices_count']?.toString() ?? "0";

        // Parse only repaired devices (total_repaired_devices)
        List<Map<String, String>> parsedList = [];
        if (data['total_repaired_devices'] != null &&
            data['total_repaired_devices'] is List) {
          for (var item in data['total_repaired_devices']) {
            String imei = item['imei']?.toString() ?? "Unknown";
            String? dealerName;
            if (item['vehicle_device_data'] != null &&
                item['vehicle_device_data'] is Map) {
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
        } else if (data['repaired_imeis'] != null &&
            data['repaired_imeis'] is List) {
          // Fallback: use repaired_imeis list if total_repaired_devices is unavailable
          for (var imei in data['repaired_imeis']) {
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
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint("API Error: $e");
      Get.snackbar(
        "Error",
        "Error fetching preview data",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
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

      final homeController = Get.find<HomeController>();
      final req = homeController.selectedCourierRequest.value;
      if (req != null) {
        final int allowed = (req.noOfNewGps ?? 0) + (req.noOfServiceGps ?? 0);
        final int currentCount = int.tryParse(totalDevices.value) ?? 0;
        if (currentCount != allowed) {
          isActionLoading.value = false;
          Get.snackbar(
            "Validation Error",
            "Please scan the exact count of GPS devices required ($allowed devices). Current count: $currentCount.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }
      }

      String targetUserType = homeController.selectedUserTypeValue.value
          .toString();
      String targetUserId = homeController.selectedUserId.value.toString();

      if (req != null && (targetUserType == "3" || targetUserType == "11")) {
        if (req.dealerId != null && req.dealerId != 0) {
          targetUserType = "1";
          targetUserId = req.dealerId.toString();
        } else if (req.technicianId != null && req.technicianId != 0) {
          targetUserType = "2";
          targetUserId = req.technicianId.toString();
        }
      }

      final String courierIdVal = (req?.id ?? req?.courierId)?.toString() ?? '';
      final int othersRepaired = int.tryParse(othersRepairedDevices.value) ?? 0;
      final String reallocateValue = courierIdVal.isNotEmpty
          ? "0"
          : (othersRepaired > 0 ? "1" : "0");

      final response = await _apiService.gpsAllocate(
        userType: targetUserType,
        userId: targetUserId,
        reallocate: reallocateValue,
        courierId: courierIdVal,
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
