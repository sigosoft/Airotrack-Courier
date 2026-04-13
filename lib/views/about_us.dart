import 'package:airotrack_courier/utils/app_colors.dart';
import 'package:airotrack_courier/widgets/custom_back_button.dart';
import 'package:airotrack_courier/widgets/custom_build_section.dart';
import 'package:airotrack_courier/widgets/custom_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/about_us_controller.dart';

class AboutUsView extends StatelessWidget {
  const AboutUsView({super.key});

  @override
  Widget build(BuildContext context) {
    final AboutUsController controller = Get.put(AboutUsController());

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: customBackButton(context),
        title: const Text(
          "About Us",
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.white),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryBlue,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const CustomLoadingIndicator();
        }

        final data = controller.aboutData.value;
        if (data == null) {
          return const Center(child: Text("No about us information available"));
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                buildSection(data.title ?? "About Us", data.content ?? ""),
              ],
            ),
          ),
        );
      }),
    );
  }
}
