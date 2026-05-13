import 'dart:async';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../views/login_view.dart';
import '../views/home_view.dart';
import '../bindings/home_binding.dart';
import '../utils/network_info.dart';
import '../views/noInternet.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    // Start navigation timer
    _startTimer();
  }

  void _startTimer() {
    Timer(const Duration(seconds: 3), () async {
      // Check for network before proceeding
      bool connected = await isNetworkAvailable();

      if (!connected) {
        Get.offAll(() => const NoInternet());
        return;
      }

      var box = Hive.box('userBox');
      String? token = box.get('token');

      if (token != null && token.isNotEmpty) {
        // Token exists, navigate to Home
        Get.offAll(() => const HomeView(), binding: HomeBinding());
      } else {
        // No token, navigate to Login
        Get.offAll(() => LoginView());
      }
    });
  }
}
