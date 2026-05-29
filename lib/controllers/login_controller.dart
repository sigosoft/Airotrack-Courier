import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';
import '../utils/network_info.dart';
import '../services/api_service.dart';
import '../views/home_view.dart';
import '../bindings/home_binding.dart';
import '../utils/error_handler.dart';

class LoginController extends GetxController {
  final ApiService _apiService = ApiService();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> login() async {
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter both username and password",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      final response = await _apiService.login(username, password);

      if (response != null && response.status == "true") {
        // Ensure box is open
        if (!Hive.isBoxOpen('userBox')) {
          await Hive.openBox('userBox');
        }
        var box = Hive.box('userBox');
        final token = response.data?.details?.token;
        box.put('token', token);
        debugPrint("LoginController received token: $token");
        box.put('userData', jsonEncode(response.data?.details?.toJson()));

        Get.snackbar(
          "Success",
          response.message ?? "Logged in successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Navigate to home
        Get.offAll(() => const HomeView(), binding: HomeBinding());
      } else {
        Get.snackbar(
          "Login Failed",
          response?.message ?? "Invalid credentials",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      String errorMessage = ErrorHandler.getErrorMessage(e);
      
      Get.snackbar(
        "Error",
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
