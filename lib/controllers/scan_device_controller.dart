import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../services/api_service.dart';

class ScanDeviceController extends GetxController {
  final MobileScannerController cameraController = MobileScannerController(autoStart: false);

  // Observable for flash state
  final isFlashOn = false.obs;
  final TextEditingController imeiController = TextEditingController();
  
  // Observable for scanner activity state
  final isScannerActive = false.obs;
  final scannerKeyCounter = 0.obs;
  Timer? _scanTimer;

  @override
  void onClose() {
    _scanTimer?.cancel();
    cameraController.stop();
    cameraController.dispose();
    imeiController.dispose();
    super.onClose();
  }

  // Toggle Flash
  void toggleFlash() {
    cameraController.toggleTorch();
    isFlashOn.value = !isFlashOn.value;
  }

  // Start scanning
  void startScanning() async {
    isScannerActive.value = true;
    scannerKeyCounter.value++;
    // Brief delay to ensure the MobileScanner widget is mounted before calling start()
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      await cameraController.start();
    } catch (e) {
      debugPrint("Error starting camera: $e");
    }
    _resetScanTimer();
  }

  // Reset or initialize the 1-minute timeout timer
  void _resetScanTimer() {
    _scanTimer?.cancel();
    _scanTimer = Timer(const Duration(minutes: 1), () async {
      try {
        await cameraController.stop();
      } catch (e) {
        debugPrint("Error stopping camera: $e");
      }
      isScannerActive.value = false;
    });
  }

  final ApiService _apiService = ApiService();
  final Set<String> _scannedBarcodes = {};
  bool _isProcessing = false;

  void onDetect(BarcodeCapture capture) async {
    _resetScanTimer();
    if (_isProcessing) return;

    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      String? imei = barcode.rawValue;
      if (imei != null) {
        if (_scannedBarcodes.contains(imei)) {
          _isProcessing = true;
          Get.snackbar(
            "Already Scanned",
            "This IMEI has already been scanned.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withOpacity(0.7),
            colorText: Colors.white,
          );
          // Briefly pause to prevent snackbar spam
          Future.delayed(const Duration(seconds: 2), () {
            _isProcessing = false;
          });
          break;
        } else {
          await _processImei(imei);
          break;
        }
      }
    }
  }

  Future<void> addManualImei() async {
    String imei = imeiController.text.trim();
    if (imei.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter an IMEI number.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
      return;
    }

    if (_scannedBarcodes.contains(imei)) {
      Get.snackbar(
        "Error",
        "This IMEI has already been added.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
      return;
    }

    await _processImei(imei);
    imeiController.clear();
  }

  Future<void> _processImei(String imei) async {
    if (_isProcessing) return;
    _isProcessing = true;
    _scannedBarcodes.add(imei);

    if (!Hive.isBoxOpen('userBox')) {
      await Hive.openBox('userBox');
    }
    var box = Hive.box('userBox');
    String? userDataString = box.get('userData');
    String userId = "";

    if (userDataString != null) {
      try {
        Map<String, dynamic> data = jsonDecode(userDataString);
        userId = data['id']?.toString() ?? "";
      } catch (e) {
        debugPrint("Error reading user data: $e");
      }
    }

    try {
      final response = await _apiService.setGpsTemporaryStorage(
        userType: "2",
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
      // Add a small delay before allowing the next scan
      // to prevent immediate duplicate scan notifications
      Future.delayed(const Duration(seconds: 2), () {
        _isProcessing = false;
      });
    }
  }

  // Go Back
  void goBack() async {
    await cameraController.stop();
    Get.back();
  }
}
