import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../views/login_view.dart';
import '../views/home_view.dart';
import '../bindings/home_binding.dart';
import '../utils/network_info.dart';
import '../views/noInternet.dart';
import '../services/api_service.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    // Start navigation timer
    _startTimer();
  }

  void _startTimer() {
    Timer(const Duration(seconds: 3), () async {
      try {
        // Check for network before proceeding
        bool connected = await isNetworkAvailable();

        if (!connected) {
          Get.offAll(() => const NoInternet());
          return;
        }

        // Ensure Hive is ready
        if (!Hive.isBoxOpen('userBox')) {
          await Hive.openBox('userBox');
        }

        var box = Hive.box('userBox');
        String? token = box.get('token');
        debugPrint("SplashController retrieved token: $token");

        if (token != null && token.isNotEmpty) {
          // User is logged in — clear both temporary storages before navigating
          try {
            await ApiService().deleteTemporaryStorage();
            debugPrint("Temporary storages cleared on app reopen");
          } catch (e) {
            debugPrint("Error clearing temporary storages on reopen: $e");
          }
          // Navigate to Home
          Get.offAll(() => const HomeView(), binding: HomeBinding());
        } else {
          // No token, navigate to Login
          Get.offAll(() => LoginView());
        }
      } catch (e) {
        debugPrint("Navigation error in Splash: $e");
        // Fallback to Login screen if something fails
        Get.offAll(() => LoginView());
      }
    });
  }
}
