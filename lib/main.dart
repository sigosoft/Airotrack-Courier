import 'package:airotrack_courier/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'utils/app_colors.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AirTrack Courier',
      theme: ThemeData(
        primaryColor: AppColors.primaryBlue,
        useMaterial3: true,
      ),
      home: const LoginView(),
    );
  }
  
}
