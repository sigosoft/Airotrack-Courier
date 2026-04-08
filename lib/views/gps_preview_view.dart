import 'package:airotrack_courier/utils/app_colors.dart';
import 'package:airotrack_courier/utils/width_height.dart';
import 'package:airotrack_courier/views/device_preview_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GpsPreviewView extends StatelessWidget {
  const GpsPreviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Preview",
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Dealer 1",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            height20,
            Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Table(
                columnWidths: const {
                  0: IntrinsicColumnWidth(),
                  1: FixedColumnWidth(20),
                  2: FlexColumnWidth(),
                },
                children: [
                  _buildStatRow("Total Devices", "100"),
                  _buildStatSpacing(),
                  _buildStatRow("New Devices", "80"),
                  _buildStatSpacing(),
                  _buildStatRow("Repaired Devices", "20"),
                ],
              ),
            ),
            height30,
            RichText(
              text: const TextSpan(
                text: 'Replaced devices count ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                children: [
                  TextSpan(
                    text: '*',
                    style: TextStyle(color: Colors.red, fontSize: 18),
                  ),
                ],
              ),
            ),
            height10,
            TextFormField(
              decoration: InputDecoration(
                hintText: "Enter device count",
                hintStyle: TextStyle(color: Colors.grey.shade400),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 15,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Get.to(() => const DevicePreviewView());
                },
                child: const Text(
                  "Submit",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            height10,
          ],
        ),
      ),
    );
  }

  TableRow _buildStatRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF444444),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 4),
          child: Text(
            ":",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF444444),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF444444),
            ),
          ),
        ),
      ],
    );
  }

  TableRow _buildStatSpacing() {
    return const TableRow(
      children: [SizedBox(height: 8), SizedBox(height: 8), SizedBox(height: 8)],
    );
  }
}
