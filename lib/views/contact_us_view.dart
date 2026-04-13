import 'package:airotrack_courier/utils/app_colors.dart';
import 'package:airotrack_courier/utils/width_height.dart';
import 'package:airotrack_courier/widgets/custom_back_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/contact_us_controller.dart';
import '../widgets/custom_loading_indicator.dart';

class ContactUsView extends StatelessWidget {
  const ContactUsView({super.key});

  @override
  Widget build(BuildContext context) {
    final ContactUsController controller = Get.put(ContactUsController());

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: customBackButton(context),
        backgroundColor: AppColors.primaryBlue,
        title: const Text(
          "Contact Us",
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const CustomLoadingIndicator();
        }

        final data = controller.contactData.value;
        if (data == null) {
          return const Center(child: Text("No contact information available"));
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Address",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
              ),
              height10,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    color: AppColors.primaryBlue,
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Text(data.address ?? "N/A")),
                ],
              ),
              const Divider(),
              const Text(
                "Email us at",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              height5,
              Text(data.email ?? "N/A"),
              height15,
              const Text(
                "Call us at",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              height5,
              Text(data.mobileNumber ?? "N/A"),
            ],
          ),
        );
      }),
    );
  }
}
