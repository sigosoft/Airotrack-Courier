import 'dart:async';
import 'package:get/get.dart';
import '../views/login_view.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    // Start navigation timer
    _startTimer();
  }

  void _startTimer() {
    Timer(const Duration(seconds: 3), () {
      // Navigate to LoginView and remove all previous routes from stack
      Get.offAll(() => const LoginView());
    });
  }
}
