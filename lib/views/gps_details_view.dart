import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/gps_details_controller.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_back_button.dart';

class GPSDetailsView extends StatelessWidget {
  const GPSDetailsView({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GPSDetailsController());
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
          'GPS Details',
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

                // Device Status Field
                _buildFieldLabel('Device Status'),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Obx(
                    () => DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: controller.selectedStatus.value,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: controller.statusOptions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) => controller.updateStatus(value),
                      ),
                    ),
                  ),
                ),

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
                          backgroundColor: const Color(0xFFE1F5FE), // Light blue
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
                      child: ElevatedButton(
                        onPressed: () => controller.onNext(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4FC3F7), 
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Next',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
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
      hintStyle: TextStyle(
        color: Colors.grey.shade400,
        fontSize: 16,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
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
    );
  }
}
