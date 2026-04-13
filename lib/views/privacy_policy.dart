import 'package:airotrack_courier/utils/app_colors.dart';
import 'package:airotrack_courier/widgets/custom_back_button.dart';
import 'package:airotrack_courier/widgets/custom_build_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/privacy_policy_controller.dart';
import '../widgets/custom_loading_indicator.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    final PrivacyPolicyController controller = Get.put(
      PrivacyPolicyController(),
    );

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: customBackButton(context),
        title: const Text(
          "Privacy Policy",
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryBlue,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const CustomLoadingIndicator();
        }

        final data = controller.policyData.value;
        if (data == null) {
          return const Center(child: Text("No privacy policy available"));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSection(data.title ?? 'Privacy Policy', data.content ?? ''),
            ],
          ),
        );
      }),
    );
  }
}
