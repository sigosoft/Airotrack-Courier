// ignore_for_file: deprecated_member_use

import 'package:airotrack_courier/utils/width_height.dart';
import 'package:airotrack_courier/views/login_view.dart';
import 'package:airotrack_courier/views/about_us.dart';
import 'package:airotrack_courier/views/contact_us_view.dart';
import 'package:airotrack_courier/views/privacy_policy.dart';
import 'package:airotrack_courier/views/terms_conditions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_app_bar.dart';
import 'gps_scan_device_view.dart';
import 'camera_details_view.dart';
import 'speed_governor_details_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    // MediaQuery for responsive design
    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height;
    final width = mediaQuery.size.width;

    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(scaffoldKey: _scaffoldKey),
      drawer: Drawer(
        backgroundColor: AppColors.white,
        elevation: 0,
        child: Column(
          children: [
            // Drawer Header
            SafeArea(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.grey,
                          size: 28,
                        ),
                        onPressed: () => Get.back(),
                      ),
                    ],
                  ),
                  Center(
                    child: Image.asset(
                      'lib/assets/images/applogo.png',
                      height: 160,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(
                    thickness: 1,
                    color: Color(0xFFF1F1F1),
                    height: 1,
                  ),
                ],
              ),
            ),
            // Drawer Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(
                    icon: Icons.contact_support_outlined,
                    label: 'Contact Us',
                    onTap: () => Get.to(() => ContactUsView()),
                  ),
                  const Divider(
                    height: 1,
                    color: Color(0xFFF1F1F1),
                    indent: 16,
                    endIndent: 16,
                  ),
                  _buildDrawerItem(
                    icon: Icons.calendar_today_outlined,
                    label: 'Terms & Conditions',
                    onTap: () => Get.to(() => TermsAndConditionsView()),
                  ),
                  const Divider(
                    height: 1,
                    color: Color(0xFFF1F1F1),
                    indent: 16,
                    endIndent: 16,
                  ),
                  _buildDrawerItem(
                    icon: Icons.shield_outlined,
                    label: 'Privacy Policy',
                    onTap: () => Get.to(() => PrivacyPolicyView()),
                  ),
                  const Divider(
                    height: 1,
                    color: Color(0xFFF1F1F1),
                    indent: 16,
                    endIndent: 16,
                  ),
                  _buildDrawerItem(
                    icon: Icons.badge_outlined,
                    label: 'About Us',
                    onTap: () => Get.to(() => AboutUsView()),
                  ),
                  const Divider(
                    height: 1,
                    color: Color(0xFFF1F1F1),
                    indent: 16,
                    endIndent: 16,
                  ),
                  _buildDrawerItem(
                    icon: Icons.logout_outlined,
                    label: 'Logout',
                    isLogout: true,
                    onTap: () {
                      Get.back(); // Close the drawer first
                      Get.dialog(
                        Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 30,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.logout_rounded,
                                  size: 80,
                                  color: AppColors.cardBlue.withOpacity(0.8),
                                ),
                                const SizedBox(height: 25),
                                const Text(
                                  "Are you sure you want to logout?",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(height: 35),
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: () => Get.back(),
                                        style: OutlinedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 14,
                                          ),
                                          side: BorderSide(
                                            color: Colors.grey.shade300,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          "No",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Get.delete<HomeController>(
                                            force: true,
                                          );
                                          Get.offAll(() => const LoginView());
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.cardBlue,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 14,
                                          ),
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          "Yes",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            // Drawer Footer
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  const Text(
                    'V1.0.0',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 5),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Check for updates',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.05,
            vertical: height * 0.03,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Card
              Container(
                width: width * 0.9,
                padding: EdgeInsets.all(width * 0.05),
                decoration: BoxDecoration(
                  color: AppColors.cardBlue,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: height * 0.01),
                    Obx(
                      () => Text(
                        controller.userProfile.value.name,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.04),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Date Info
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_month_outlined,
                              color: AppColors.white,
                              size: 20,
                            ),
                            SizedBox(width: width * 0.02),
                            Obx(
                              () => Text(
                                controller.userProfile.value.date,
                                style: const TextStyle(
                                  color: AppColors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Time Info
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              color: AppColors.white,
                              size: 20,
                            ),
                            SizedBox(width: width * 0.02),
                            Obx(
                              () => Text(
                                controller.userProfile.value.time,
                                style: const TextStyle(
                                  color: AppColors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: height * 0.04),

              // User Type Label with Red Asterisk
              RichText(
                text: const TextSpan(
                  text: 'User Type',
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 18,
                    // fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: '*',
                      style: TextStyle(
                        color: AppColors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: height * 0.02),

              // Dropdown Selection Field
              Container(
                padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Obx(
                  () => DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value:
                          controller.userProfile.value.selectedUserType ==
                              'Select User Type'
                          ? null
                          : controller.userProfile.value.selectedUserType,
                      hint: Text(
                        controller.userProfile.value.selectedUserType,
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 16,
                        ),
                      ),
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.black,
                      ),
                      items: controller.userProfile.value.userTypeOptions.map((
                        String value,
                      ) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        controller.updateSelectedUserType(newValue);
                        controller.searchController
                            .clear(); // Clear search on type change
                      },
                    ),
                  ),
                ),
              ),
              // Dealer/Technician Search Section (Conditional)
              Obx(() {
                String? selectedType =
                    controller.userProfile.value.selectedUserType;
                if (selectedType == 'Dealer' || selectedType == 'Technician') {
                  bool isDealer = selectedType == 'Dealer';
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: height * 0.02),
                      RichText(
                        text: TextSpan(
                          text: isDealer ? 'Dealer' : 'Technician',
                          style: const TextStyle(
                            color: AppColors.black,
                            fontSize: 18,
                          ),
                          children: const [
                            TextSpan(
                              text: '*',
                              style: TextStyle(
                                color: AppColors.red,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),                     
                      SizedBox(height: height * 0.015),
                      TextFormField(
                        controller: controller.searchController,
                        focusNode: controller.searchFocusNode,
                        onChanged: (value) => controller.filterResults(value),
                        autocorrect: false,
                        decoration: InputDecoration(
                          hintText: isDealer
                              ? "Search Dealer"
                              : "Search Technician",
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 16,
                          ),
                          suffixIcon: controller.isDealerSelected.value
                              ? null
                              : const Icon(
                                  Icons.search,
                                  color: AppColors.black,
                                  size: 24,
                                ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: width * 0.03,
                            vertical: 18,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: AppColors.primaryBlue,
                            ),
                          ),
                        ),
                      ),
                      // Search Results List
                      Obx(() {
                        if (controller.showResults.value) {
                          return Container(
                            margin: const EdgeInsets.only(top: 5),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.filteredResults.length,
                              itemBuilder: (context, index) {
                                final result =
                                    controller.filteredResults[index];
                                return ListTile(
                                  title: Text(
                                    result,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  onTap: () => controller.selectDealer(result),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  dense: true,
                                );
                              },
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      }),
                    ],
                  );
                }
                return const SizedBox.shrink();
              }),

              // Device Type Section (Conditional on SELECTION)
              Obx(() {
                if (controller.isDealerSelected.value) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: height * 0.02),
                      RichText(
                        text: const TextSpan(
                          text: 'Device Type',
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 18,
                          ),
                          children: [
                            TextSpan(
                              text: '*',
                              style: TextStyle(
                                color: AppColors.red,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: height * 0.015),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Obx(
                          () => DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: controller.selectedDeviceType.value.isEmpty
                                  ? null
                                  : controller.selectedDeviceType.value,
                              hint: Text(
                                "Select Device Type",
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 16,
                                ),
                              ),
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: AppColors.black,
                              ),
                              items: controller.deviceTypeOptions.map((
                                String value,
                              ) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  controller.updateDeviceType(newValue);
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                      height50,
                      Obx(
                        () => controller.selectedDeviceType.value.isNotEmpty
                            ? Column(
                                children: [
                                  if (controller.selectedDeviceType.value ==
                                      "GPS") ...[
                                    SizedBox(
                                      width: double.infinity,
                                      height: 55,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColors.primaryBlue,
                                          foregroundColor: Colors.white,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                        onPressed: () => Get.to(
                                          () => const GpsScanDeviceView(),
                                        ),
                                        child: const Text(
                                          "Submit and Scan Device",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ] else ...[
                                    SizedBox(
                                      width: double.infinity,
                                      height: 55,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primaryBlue,
                                          foregroundColor: Colors.white,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          if (controller
                                                  .selectedDeviceType
                                                  .value ==
                                              'Camera') {
                                            Get.to(
                                              () => const CameraDetailsView(),
                                            );
                                          } else if (controller
                                                  .selectedDeviceType
                                                  .value ==
                                              'Speed Governor') {
                                            Get.to(
                                              () =>
                                                  const SpeedGovernorDetailsView(),
                                            );
                                          } else if (controller
                                                  .selectedDeviceType
                                                  .value ==
                                              'GPS') {
                                            Get.to(
                                              () => const GpsScanDeviceView(),
                                            );
                                          }
                                        },
                                        child: const Text(
                                          "Submit and Enter Details",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              )
                            : const SizedBox.shrink(),
                      ),
                      SizedBox(height: height * 0.02),
                    ],
                  );
                }
                return const SizedBox.shrink();
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    Color itemColor = isLogout ? Colors.red : Colors.black87;
    Color iconColor = isLogout ? Colors.red : Colors.grey.shade600;

    return ListTile(
      leading: Icon(icon, color: iconColor, size: 24),
      title: Text(
        label,
        style: TextStyle(
          color: itemColor,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: iconColor, size: 20),
      onTap: onTap,
    );
  }
}
