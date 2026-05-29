import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../services/api_service.dart';
import '../models/terms_and_conditions_response.dart';
import '../utils/error_handler.dart';

class TermsAndConditionsController extends GetxController {
  final ApiService _apiService = ApiService();

  final Rxn<TermsAndConditions> termsData = Rxn<TermsAndConditions>();
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTerms();
  }

  Future<void> fetchTerms() async {
    isLoading.value = true;
    try {
      final response = await _apiService.getTermsAndConditions();
      if (response != null && response.status == true) {
        termsData.value = response.data?.termsAndConditions;
      } else {
        Get.snackbar(
          "Error",
          response?.message ?? "Failed to fetch terms and conditions",
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
