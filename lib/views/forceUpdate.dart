import 'dart:io';

import 'package:airotrack_courier/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/app_colors.dart';

class ForceUpdate extends StatelessWidget {
  const ForceUpdate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                SizedBox(
                  height: 200,
                  child: Image.asset('lib/assets/images/logosplash.svg'),
                ),
                const SizedBox(height: 20),
                const Text(
                  Strings.updateMsg,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'Poppins-Bold',
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  Strings.updateAvailable,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontFamily: 'Poppins-Regular',
                  ),
                ),
                const Text(
                  Strings.downloadLatest,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontFamily: 'Poppins-Regular',
                  ),
                ),
                const Text(
                  Strings.continueApp,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontFamily: 'Poppins-Regular',
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: SizedBox(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: AppColors.primaryBlue,
                  ),
                  onPressed: () async {
                    await launchUrl(
                      Uri.parse(
                        'https://play.google.com/store/apps/details?id=airotrack.technician',
                      ),
                    );
                  },
                  child: const Text(
                    Strings.update,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Platform.isIOS
            ? Image.asset(
                'lib/assets/images/appstore.svg',
                width: 100,
                height: 10,
              )
            : Image.asset("lib/assets/images/playstore1.png"),
      ),
    );
  }
}
