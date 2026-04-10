import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

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


  // Handle Scanning results
  void onDetect(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      if (barcode.rawValue != null) {
        Get.back(result: barcode.rawValue);
        break;
      }
    }
  }

  // Go Back
  void goBack() {
    Get.back();
  }
}
