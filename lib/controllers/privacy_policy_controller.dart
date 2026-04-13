import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../services/api_service.dart';
import '../models/privacy_policy_response.dart';

class PrivacyPolicyController extends GetxController {
  final ApiService _apiService = ApiService();

  final Rxn<PrivacyPolicy> policyData = Rxn<PrivacyPolicy>();
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPrivacyPolicy();
  }

  Future<void> fetchPrivacyPolicy() async {
    isLoading.value = true;
    try {
      final response = await _apiService.getPrivacyPolicy();
      if (response != null && response.status == true) {
        policyData.value = response.data?.privacyPolicy;
      } else {
        Get.snackbar(
          "Error",
          response?.message ?? "Failed to fetch privacy policy",
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
