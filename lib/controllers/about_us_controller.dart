import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../services/api_service.dart';
import '../models/about_us_response.dart';
import '../utils/error_handler.dart';

class AboutUsController extends GetxController {
  final ApiService _apiService = ApiService();

  final Rxn<AboutUs> aboutData = Rxn<AboutUs>();
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAboutUs();
  }

  Future<void> fetchAboutUs() async {
    isLoading.value = true;
    try {
      final response = await _apiService.getAboutUs();
      if (response != null && response.status == true) {
        aboutData.value = response.data?.aboutUs;
      } else {
        Get.snackbar(
          "Error",
          response?.message ?? "Failed to fetch about us information",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      _handleApiError(e);
    } finally {
      isLoading.value = false;
    }
  }

  void _handleApiError(dynamic e) {
    final errorMessage = ErrorHandler.getErrorMessage(e);
    Get.snackbar(
      "Error",
      errorMessage,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}
