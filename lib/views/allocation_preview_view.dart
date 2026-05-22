import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/app_colors.dart';
import '../utils/width_height.dart';
import '../widgets/custom_back_button.dart';
import '../controllers/home_controller.dart';
import '../services/api_service.dart';
import 'allocation_success_view.dart';
import 'camera_details_view.dart';
import 'speed_governor_details_view.dart';

class AllocationPreviewView extends StatelessWidget {
  const AllocationPreviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        elevation: 0,
        leading: customBackButton(context),
        title: const Text(
          'Preview',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Text(
                    homeController.selectedDealerName.value.isEmpty
                        ? "Dealer 1"
                        : homeController.selectedDealerName.value,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                ),
                height20,
                Container(
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Obx(() {
                    List<Widget> rows = [];

                    // Total row
                    rows.add(
                      _buildInfoRow(
                        "Total Devices",
                        "${homeController.totalDevicesCount}",
                      ),
                    );

                    // Camera rows
                    if (homeController.newCameraCount.value > 0) {
                      rows.add(const SizedBox(height: 15));
                      rows.add(
                        _buildInfoRow(
                          "New Camera",
                          "${homeController.newCameraCount.value}",
                        ),
                      );
                    }
                    if (homeController.repairedCameraCount.value > 0) {
                      rows.add(const SizedBox(height: 15));
                      rows.add(
                        _buildInfoRow(
                          "Repaired Camera",
                          "${homeController.repairedCameraCount.value}",
                        ),
                      );
                    }

                    // Speed Governor rows
                    if (homeController.newSpeedGovernorCount.value > 0) {
                      rows.add(const SizedBox(height: 15));
                      rows.add(
                        _buildInfoRow(
                          "New Speed Governor",
                          "${homeController.newSpeedGovernorCount.value}",
                        ),
                      );
                    }
                    if (homeController.repairedSpeedGovernorCount.value > 0) {
                      rows.add(const SizedBox(height: 15));
                      rows.add(
                        _buildInfoRow(
                          "Repaired Speed Governor",
                          "${homeController.repairedSpeedGovernorCount.value}",
                        ),
                      );
                    }

                    return Column(children: rows);
                  }),
                ),
              ],
            ),
          ),

          // Bottom Buttons
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(20),
              color: AppColors.white,
              child: Row(
                children: [
                  // Add More button — commented out as per requirement
                  // Expanded(
                  //   child: SizedBox(
                  //     height: 55,
                  //     child: ElevatedButton(
                  //       onPressed: () => _showAddDeviceDialog(context, homeController),
                  //       style: ElevatedButton.styleFrom(
                  //         backgroundColor: const Color(0xFFE1F5FE),
                  //         foregroundColor: AppColors.primaryBlue,
                  //         elevation: 0,
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(10),
                  //         ),
                  //       ),
                  //       child: const Text(
                  //         'Add More',
                  //         style: TextStyle(
                  //           fontSize: 18,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(width: 15),
                  Expanded(
                    child: SizedBox(
                      height: 55,
                      child: Obx(() {
                        final isAllocating = homeController.isAllocating.value;
                        return ElevatedButton(
                          onPressed: isAllocating
                              ? null
                              : () async {
                                  final req = homeController
                                      .selectedCourierRequest
                                      .value;
                                  if (req != null) {
                                    // 1. Camera Validation
                                    final int allowedCameras =
                                        (req.noOfNewCameras ?? 0) +
                                        (req.noOfServiceCameras ?? 0);
                                    final int enteredCameras =
                                        homeController.newCameraCount.value +
                                        homeController
                                            .repairedCameraCount
                                            .value;
                                    if (enteredCameras != allowedCameras) {
                                      Get.snackbar(
                                        "Validation Error",
                                        "Please enter the exact count of Cameras required ($allowedCameras devices). Current count: $enteredCameras.",
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: Colors.red,
                                        colorText: Colors.white,
                                      );
                                      return;
                                    }

                                    // 2. Speed Governor Validation
                                    final int allowedSgs =
                                        (req.noOfNewSpeedGovernors ?? 0) +
                                        (req.noOfServiceSpeedGovernors ?? 0);
                                    final int enteredSgs =
                                        homeController
                                            .newSpeedGovernorCount
                                            .value +
                                        homeController
                                            .repairedSpeedGovernorCount
                                            .value;
                                    if (enteredSgs != allowedSgs) {
                                      Get.snackbar(
                                        "Validation Error",
                                        "Please enter the exact count of Speed Governors required ($allowedSgs devices). Current count: $enteredSgs.",
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: Colors.red,
                                        colorText: Colors.white,
                                      );
                                      return;
                                    }
                                  }

                                  homeController.isAllocating.value = true;
                                  try {
                                    final apiService = ApiService();
                                    final result = await apiService
                                        .cameraSpeedGovernorAllocate(
                                          userType: homeController
                                              .selectedUserTypeValue
                                              .value
                                              .toString(),
                                          userId: homeController
                                              .selectedUserId
                                              .value
                                              .toString(),
                                          courierId:
                                              (homeController
                                                          .selectedCourierRequest
                                                          .value
                                                          ?.id ??
                                                      homeController
                                                          .selectedCourierRequest
                                                          .value
                                                          ?.courierId)
                                                  ?.toString() ??
                                              '',
                                        );
                                    final success =
                                        result != null &&
                                        (result['status'] == true ||
                                            result['status'] == 'true');
                                    if (success) {
                                      Get.offAll(
                                        () => AllocationSuccessScreen(),
                                      );
                                    } else {
                                      Get.snackbar(
                                        'Error',
                                        result?['message'] ??
                                            'Allocation failed. Please try again.',
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: Colors.red,
                                        colorText: Colors.white,
                                      );
                                    }
                                  } catch (e) {
                                    Get.snackbar(
                                      'Error',
                                      'An unexpected error occurred.',
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                  } finally {
                                    homeController.isAllocating.value = false;
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF4FC3F7),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: isAllocating
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Submit',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF444444),
            ),
          ),
        ),
        const Expanded(
          flex: 1,
          child: Text(
            ":",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF444444),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF444444),
            ),
          ),
        ),
      ],
    );
  }

  // _showAddDeviceDialog is kept commented out alongside the Add More button.
  // void _showAddDeviceDialog(BuildContext context, HomeController homeController) {
  //   String? selectedType;
  //   Get.dialog(
  //     Dialog(
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
  //       child: Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             RichText(
  //               text: const TextSpan(
  //                 text: 'Device Type',
  //                 style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
  //                 children: [
  //                   TextSpan(text: '*', style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold)),
  //                 ],
  //               ),
  //             ),
  //             const SizedBox(height: 15),
  //             DropdownButtonFormField<String>(
  //               decoration: InputDecoration(
  //                 contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
  //                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
  //                 enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
  //               ),
  //               hint: const Text("Select Device Type"),
  //               items: homeController.deviceTypeOptions.where((type) => type != 'GPS').map((String value) {
  //                 return DropdownMenuItem<String>(value: value, child: Text(value));
  //               }).toList(),
  //               onChanged: (newValue) => selectedType = newValue,
  //             ),
  //             const SizedBox(height: 30),
  //             Row(
  //               children: [
  //                 Expanded(
  //                   child: SizedBox(
  //                     height: 50,
  //                     child: ElevatedButton(
  //                       onPressed: () => Get.back(),
  //                       style: ElevatedButton.styleFrom(
  //                         backgroundColor: const Color(0xFFE1F5FE),
  //                         foregroundColor: AppColors.primaryBlue,
  //                         elevation: 0,
  //                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  //                       ),
  //                       child: const Text("Cancel", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
  //                     ),
  //                   ),
  //                 ),
  //                 const SizedBox(width: 15),
  //                 Expanded(
  //                   child: SizedBox(
  //                     height: 50,
  //                     child: ElevatedButton(
  //                       onPressed: () {
  //                         if (selectedType != null) {
  //                           Get.back();
  //                           if (selectedType == 'Camera') {
  //                             Get.to(() => const CameraDetailsView());
  //                           } else if (selectedType == 'Speed Governor') {
  //                             Get.to(() => const SpeedGovernorDetailsView());
  //                           }
  //                         }
  //                       },
  //                       style: ElevatedButton.styleFrom(
  //                         backgroundColor: AppColors.primaryBlue,
  //                         foregroundColor: Colors.white,
  //                         elevation: 0,
  //                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  //                       ),
  //                       child: const Text("Submit", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
