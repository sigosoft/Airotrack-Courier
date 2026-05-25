import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';

class AppLifecycleController extends GetxController
    with WidgetsBindingObserver {
  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      debugPrint("App is closing, calling deleteTemporaryStorage API");
      try {
        _apiService.deleteTemporaryStorage();
      } catch (e) {
        debugPrint("Error calling deleteTemporaryStorage on close: $e");
      }
    }
  }
}
