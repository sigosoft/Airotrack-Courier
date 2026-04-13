import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../services/api_service.dart';
import '../models/contact_us_response.dart';

class ContactUsController extends GetxController {
  final ApiService _apiService = ApiService();

  final Rxn<ContactUs> contactData = Rxn<ContactUs>();
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchContactUs();
  }

  Future<void> fetchContactUs() async {
    isLoading.value = true;
    try {
      final response = await _apiService.getContactUs();
      if (response != null && response.status == true) {
        contactData.value = response.data?.contactUs;
      } else {
        Get.snackbar(
          "Error",
          response?.message ?? "Failed to fetch contact details",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.7),
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
    String errorMessage = "Something went wrong. Please try again later.";
    if (e is DioException) {
      var data = e.response?.data;
      if (data != null && data is Map && data['message'] != null) {
        errorMessage = data['message'].toString();
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
  }
}
