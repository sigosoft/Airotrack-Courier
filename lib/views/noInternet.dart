import 'dart:async';
import 'package:airotrack_courier/views/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/app_strings.dart';
import '../utils/app_assets.dart';
import '../utils/network_info.dart';

class NoInternet extends StatefulWidget {
  const NoInternet({super.key});

  @override
  State<NoInternet> createState() => _NoInternetState();
}

class _NoInternetState extends State<NoInternet> {
  Timer? _networkCheckTimer;

  @override
  void initState() {
    super.initState();
    _checkNetwork();
    _networkCheckTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _checkNetwork();
    });
  }

  @override
  void dispose() {
    _networkCheckTimer?.cancel();
    super.dispose();
  }

  Future<void> _checkNetwork() async {
    if (await isNetworkAvailable()) {
      _networkCheckTimer?.cancel();
      Get.offAll(() => const SplashView());
    } else {
      debugPrint("No internet");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              AppAssets.noInternet,
              height: 200,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 30),
            const Text(
              Strings.noInternet,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              Strings.checkInternet,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
            ),
            const Text(
              Strings.again,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
