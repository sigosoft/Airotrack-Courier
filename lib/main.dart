import 'package:airotrack_courier/views/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'utils/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Hive.initFlutter();
    await Hive.openBox('userBox');
  } catch (e) {
    debugPrint("Hive initialization error: $e");
  }
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AirTrack Courier',
      theme: ThemeData(primaryColor: AppColors.primaryBlue, useMaterial3: true),
      home: const SplashView(),
    );
  }
}
