import 'package:airotrack_courier/views/gps_device_preview_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/app_colors.dart';
import '../utils/width_height.dart';
import '../widgets/custom_back_button.dart';
import '../controllers/home_controller.dart';

class GpsPreviewView extends StatelessWidget {
  const GpsPreviewView({super.key});

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
                Obx(() => Text(
                  homeController.selectedDealerName.value.isEmpty 
                      ? "Dealer 1" 
                      : homeController.selectedDealerName.value,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                )),
                height20,
                Container(
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildInfoRow("Total Devices", "100"),
                      const SizedBox(height: 15),
                      _buildInfoRow("New Devices", "80"),
                      const SizedBox(height: 15),
                      _buildInfoRow("Repaired Devices", "20"),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                // Replaced devices count Field
                _buildFieldLabel('Replaced devices count'),
                const SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: _buildInputDecoration('Enter device count'),
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
              width: double.infinity,
              child: SizedBox(
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(() => const GpsDevicePreviewView());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Submit',
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
    );
  }

  Widget _buildFieldLabel(String label) {
    return RichText(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          color: Color(0xFF333333),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        children: const [
          TextSpan(
            text: ' *',
            style: TextStyle(
              color: Colors.red,
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

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
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
}
