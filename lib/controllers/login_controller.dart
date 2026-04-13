import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';
import '../services/api_service.dart';
import '../views/home_view.dart';
import '../bindings/home_binding.dart';

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
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      final response = await _apiService.login(username, password);

      if (response != null && response.status == "true") {
        var box = Hive.box('userBox');
        box.put('token', response.data?.details?.token);
        box.put('userData', jsonEncode(response.data?.details?.toJson()));

        Get.snackbar(
          "Success",
          response.message ?? "Logged in successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.7),
          colorText: Colors.white,
        );

        // Navigate to home
        Get.offAll(() => const HomeView(), binding: HomeBinding());
      } else {
        Get.snackbar(
          "Login Failed",
          response?.message ?? "Invalid credentials",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.7),
          colorText: Colors.white,
        );
      }
    } catch (e) {
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
    } finally {
      isLoading.value = false;
    }
  }
}
