import 'package:airotrack_courier/widgets/custom_back_button.dart';
import 'package:airotrack_courier/widgets/custom_build_section.dart';
import 'package:airotrack_courier/widgets/custom_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/app_colors.dart';
import '../controllers/terms_and_conditions_controller.dart';

class TermsAndConditionsView extends StatelessWidget {
  const TermsAndConditionsView({super.key});

  @override
  Widget build(BuildContext context) {
    final TermsAndConditionsController controller = Get.put(
      TermsAndConditionsController(),
    );

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        elevation: 0,
        leading: customBackButton(context),
        title: const Text(
          'Terms & Conditions',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const CustomLoadingIndicator();
        }

        final data = controller.termsData.value;
        if (data == null) {
          return const Center(
            child: Text("No terms and conditions information available"),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSection(
                data.title ?? 'Terms and Conditions',
                data.content ?? '',
              ),
            ],
          ),
        );
      }),
    );
  }
}
