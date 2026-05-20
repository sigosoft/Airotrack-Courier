// ignore_for_file: deprecated_member_use

import 'package:airotrack_courier/utils/app_assets.dart';
import 'package:airotrack_courier/utils/width_height.dart';
import 'package:airotrack_courier/views/login_view.dart';
import 'package:airotrack_courier/views/about_us.dart';
import 'package:airotrack_courier/views/contact_us_view.dart';
import 'package:airotrack_courier/views/privacy_policy.dart';
import 'package:airotrack_courier/views/terms_conditions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../controllers/home_controller.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_app_bar.dart';
import '../models/courier_requests_response.dart';
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.settings(context);
    });
  }

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
                      AppAssets.logo,
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
                                          Hive.box('userBox').clear();
                                          Get.delete<HomeController>(
                                            force: true,
                                          );
                                          Get.offAll(() => LoginView());
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
      body: RefreshIndicator(
        color: AppColors.primaryBlue,
        onRefresh: () async {
          await controller.fetchCourierRequests();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                      Obx(
                        () => Text(
                          controller.userProfile.value.name,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 20,
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
                        items: controller.userProfile.value.userTypeOptions.map(
                          (String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          },
                        ).toList(),
                        onChanged: (String? newValue) {
                          controller.updateSelectedUserType(newValue);
                          controller.searchController
                              .clear(); // Clear search on type change
                        },
                      ),
                    ),
                  ),
                ),

                Obx(() {
                  final selectedType =
                      controller.userProfile.value.selectedUserType;
                  if (selectedType == 'Select User Type' ||
                      selectedType.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: height * 0.03),

                      // Courier Request Header
                      const Text(
                        'Courier Request',
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: height * 0.02),

                      // Courier Requests List
                      if (controller.isCourierRequestsLoading.value)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: CircularProgressIndicator(
                              color: AppColors.primaryBlue,
                            ),
                          ),
                        )
                      else ...[
                        if (controller.filteredCourierRequests.isEmpty)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Text(
                                'No courier requests found',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount:
                                controller.filteredCourierRequests.length,
                            itemBuilder: (context, index) {
                              final request =
                                  controller.filteredCourierRequests[index];
                              return _buildCourierRequestCard(request);
                            },
                          ),
                      ],
                    ],
                  );
                }),
                // Dealer/Technician Search Section (Conditional)
                Obx(() {
                  String? selectedType =
                      controller.userProfile.value.selectedUserType;
                  if (selectedType == 'Dealer' ||
                      selectedType == 'Technician' ||
                      selectedType == 'Customer') {
                    final String displayName = selectedType == 'Dealer'
                        ? 'Dealer'
                        : selectedType == 'Technician'
                        ? 'Technician'
                        : 'Customer';
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: height * 0.02),
                        RichText(
                          text: TextSpan(
                            text: displayName,
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
                            hintText: "Search $displayName",
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
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
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
                                    onTap: () =>
                                        controller.selectDealer(result),
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
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.03,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Obx(
                            () => DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value:
                                    controller.selectedDeviceType.value.isEmpty
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
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
                                            backgroundColor:
                                                AppColors.primaryBlue,
                                            foregroundColor: Colors.white,
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
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

  Widget _buildCourierRequestCard(CourierRequest request) {
    final int reqUserId;
    final String roleLabel;
    if (request.courierUserType == 1) {
      reqUserId = request.dealerId ?? 0;
      roleLabel = 'Dealer';
    } else if (request.courierUserType == 2) {
      reqUserId = request.technicianId ?? 0;
      roleLabel = 'Technician';
    } else {
      reqUserId = request.customerId ?? 0;
      roleLabel = 'Customer';
    }

    final bool isSelected =
        controller.isDealerSelected.value &&
        controller.selectedCourierRequest.value?.id == request.id;

    final int cameraCount =
        (request.noOfNewCameras ?? 0) + (request.noOfServiceCameras ?? 0);
    final int gpsCount =
        (request.noOfNewGps ?? 0) + (request.noOfServiceGps ?? 0);
    final int sgCount =
        (request.noOfNewSpeedGovernors ?? 0) +
        (request.noOfServiceSpeedGovernors ?? 0);

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isSelected ? AppColors.primaryBlue : Colors.grey.shade200,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          final String typeName;
          if (request.courierUserType == 1) {
            typeName = 'Dealer';
          } else if (request.courierUserType == 2) {
            typeName = 'Technician';
          } else {
            typeName = 'Customer';
          }
          controller.userProfile.update((val) {
            val?.selectedUserType = typeName;
          });
          controller.selectedUserTypeValue.value = request.courierUserType ?? 1;
          controller.selectedUserId.value = reqUserId;
          controller.selectedDealerName.value = request.courierUserName ?? '';
          controller.searchController.text = request.courierUserName ?? '';
          controller.isDealerSelected.value = true;
          controller.selectedCourierRequest.value = request;

          // Automatically select device type based on counts in the request
          if (gpsCount > 0) {
            controller.selectedDeviceType.value = 'GPS';
          } else if (cameraCount > 0) {
            controller.selectedDeviceType.value = 'Camera';
          } else if (sgCount > 0) {
            controller.selectedDeviceType.value = 'Speed Governor';
          } else {
            controller.selectedDeviceType.value = '';
          }

          controller.fetchAllocationCounts();
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "#AT-${request.id ?? request.courierId ?? ''}",
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_month_outlined,
                        color: Colors.grey,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        formatDateString(request.createdAt),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(color: Color(0xFFF1F1F1), height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    roleLabel,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    request.courierUserName ?? '',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Divider(color: Color(0xFFF1F1F1), height: 20),
              if (cameraCount > 0) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.black87,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "Camera",
                          style: TextStyle(color: Colors.black87, fontSize: 14),
                        ),
                      ],
                    ),
                    _buildCountBadge(cameraCount),
                  ],
                ),
                if (gpsCount > 0 || sgCount > 0) const SizedBox(height: 10),
              ],
              if (gpsCount > 0) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: Colors.black87,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "GPS",
                          style: TextStyle(color: Colors.black87, fontSize: 14),
                        ),
                      ],
                    ),
                    _buildCountBadge(gpsCount),
                  ],
                ),
                if (sgCount > 0) const SizedBox(height: 10),
              ],
              if (sgCount > 0) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.speed_outlined,
                          color: Colors.black87,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "Speed Governor",
                          style: TextStyle(color: Colors.black87, fontSize: 14),
                        ),
                      ],
                    ),
                    _buildCountBadge(sgCount),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCountBadge(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        "x$count",
        style: const TextStyle(
          color: Color(0xFF1E88E5),
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  String formatDateString(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      DateTime dateTime = DateTime.parse(dateStr).toLocal();
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      String day = dateTime.day.toString().padLeft(2, '0');
      String month = months[dateTime.month - 1];
      String year = dateTime.year.toString();
      return "$day $month $year";
    } catch (e) {
      return dateStr;
    }
  }
}

class Maintenance extends StatelessWidget {
  const Maintenance({super.key, required this.serverDownReason});
  final String? serverDownReason;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  "assets/images/maintenance.png",
                  height: 180,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.build, size: 100, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "We'll be back soon",
                style: TextStyle(
                  fontFamily: 'Rubik',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Text(
                  serverDownReason.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
