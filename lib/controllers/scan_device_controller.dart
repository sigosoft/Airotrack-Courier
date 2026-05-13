import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../services/api_service.dart';

class ScanDeviceController extends GetxController {
  final MobileScannerController cameraController = MobileScannerController();
  
  // Observable for flash state
  final isFlashOn = false.obs;

  @override
  void onClose() {
    cameraController.dispose();
    super.onClose();
  }

  // Toggle Flash
  void toggleFlash() {
    cameraController.toggleTorch();
    isFlashOn.value = !isFlashOn.value;
  }

  final ApiService _apiService = ApiService();
  final Set<String> _scannedBarcodes = {};
  bool _isProcessing = false;

  void onDetect(BarcodeCapture capture) async {
    if (_isProcessing) return;

    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      if (barcode.rawValue != null && !_scannedBarcodes.contains(barcode.rawValue)) {
        _isProcessing = true;
        String imei = barcode.rawValue!;
        _scannedBarcodes.add(imei);

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
            // The request specified user_type: "2", fallback to role_id if not strictly 2.
            // Using "2" as default as per requirements.
            userType = data['role_id']?.toString() ?? "2";
          } catch (e) {
            debugPrint("Error reading user data: $e");
          }
        }

        try {
          final response = await _apiService.setGpsTemporaryStorage(
            userType: "2", // Using exact "2" per user's prompt request example
            userId: userId,
            imei: imei,
          );

          if (response != null && response['status'] == true) {
            Get.snackbar(
              "Success",
              response['message'] ?? "Temporary GPS data stored successfully.",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green.withOpacity(0.7),
              colorText: Colors.white,
            );
          } else {
            _scannedBarcodes.remove(imei);
            Get.snackbar(
              "Error",
              response?['message'] ?? "Failed to store GPS data.",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red.withOpacity(0.7),
              colorText: Colors.white,
            );
          }
        } catch (e) {
          _scannedBarcodes.remove(imei);
          debugPrint("Scan API Error: $e");
        } finally {
          _isProcessing = false;
        }

        break;
      }
    }
  }

  // Go Back
  void goBack() {
    Get.back();
  }
}
