import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';
import '../utils/network_info.dart';
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
        // Ensure box is open
        if (!Hive.isBoxOpen('userBox')) {
          await Hive.openBox('userBox');
        }
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
        if (e.type == DioExceptionType.connectionTimeout || 
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.sendTimeout) {
          errorMessage = "Connection timed out. Please check your network speed.";
        } else if (e.type == DioExceptionType.connectionError) {
          errorMessage = "No internet connection or server unreachable.";
        } else if (e.type == DioExceptionType.badCertificate) {
          errorMessage = "Security certificate error. Please check your system date/time.";
        } else if (e.type == DioExceptionType.unknown) {
          errorMessage = "Network Error: ${e.error ?? e.message ?? 'Server connection failed'}";
        } else {
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
            errorMessage = e.message ?? "Server error (${e.response?.statusCode ?? 'unknown'})";
          }
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
