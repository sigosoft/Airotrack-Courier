import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/speed_governor_details_controller.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_back_button.dart';

class SpeedGovernorDetailsView extends StatelessWidget {
  const SpeedGovernorDetailsView({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SpeedGovernorDetailsController());
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        elevation: 0,
        leading: customBackButton(context),
        title: const Text(
          'Speed Governor Details',
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
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.05,
              vertical: height * 0.03,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Serial Number Field
                _buildFieldLabel('Serial Number'),
                const SizedBox(height: 10),
                TextFormField(
                  controller: controller.serialController,
                  decoration: _buildInputDecoration('Enter serial number'),
                ),

                const SizedBox(height: 25),

                // Amount Field
                _buildFieldLabel('Amount'),
                const SizedBox(height: 10),
                TextFormField(
                  controller: controller.amountController,
                  keyboardType: TextInputType.number,
                  decoration: _buildInputDecoration('Enter amount'),
                ),

                const SizedBox(height: 25),
                _buildFieldLabel('Speed Governor'),
                const SizedBox(height: 10),
                TextFormField(
                  controller: controller.governorSearchController,
                  focusNode: controller.governorFocusNode,
                  decoration: _buildInputDecoration('Search Speed Governor').copyWith(
                    suffixIcon: Obx(() => controller.isGovernorSelected.value
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.grey),
                            onPressed: () {
                              controller.governorSearchController.clear();
                              controller.selectedGovernorId.value = null;
                              controller.isGovernorSelected.value = false;
                            },
                          )
                        : const Icon(Icons.search, color: Colors.grey)),
                  ),
                  onChanged: controller.filterGovernors,
                  onTap: controller.onSearchFieldTap,
                ),

                // Search Results List
                Obx(() => controller.showGovernorResults.value
                    ? Container(
                        constraints: const BoxConstraints(maxHeight: 200),
                        margin: const EdgeInsets.only(top: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: controller.filteredGovernors.length,
                          separatorBuilder: (context, index) => Divider(
                            height: 1,
                            color: Colors.grey.shade200,
                          ),
                          itemBuilder: (context, index) {
                            final governor = controller.filteredGovernors[index];
                            return ListTile(
                              title: Text(
                                governor.sgModel ?? "Unknown Model",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              subtitle: Text(
                                "${governor.vehicleModel ?? ""} - ${governor.companyName ?? ""}",
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                              ),
                              onTap: () => controller.selectGovernor(governor),
                            );
                          },
                        ),
                      )
                    : const SizedBox.shrink()),

                const SizedBox(height: 100), // Space for bottom buttons
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
                  // Preview Button
                  Expanded(
                    child: SizedBox(
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () => controller.onPreview(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                            0xFFE1F5FE,
                          ), // Light blue
                          foregroundColor: AppColors.primaryBlue,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Preview',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  // Next Button
                  Expanded(
                    child: SizedBox(
                      height: 55,
                      child: Obx(
                        () => ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : () => controller.onNext(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4FC3F7),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: controller.isLoading.value
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Next',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
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

  Widget _buildFieldLabel(String label) {
    return RichText(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          color: AppColors.black,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        children: const [
          TextSpan(
            text: ' *',
            style: TextStyle(
              color: AppColors.red,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 16),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
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
        borderSide: const BorderSide(color: AppColors.primaryBlue),
      ),
    );
  }
}
