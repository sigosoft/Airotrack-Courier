import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_back_button.dart';
import 'allocation_success_view.dart';

class DevicePreviewView extends StatefulWidget {
  const DevicePreviewView({super.key});

  @override
  State<DevicePreviewView> createState() => _DevicePreviewViewState();
}

class _DevicePreviewViewState extends State<DevicePreviewView> {
  // Local list to manage devices dynamically
  final List<Map<String, String>> devices = [
    {'serial': '866334070322306', 'dealer': 'Dealer 2'},
    {'serial': '386334070322306', 'dealer': 'Dealer 5'},
    {'serial': '866334070322306', 'dealer': 'Dealer 2'},
    {'serial': '386334070322306', 'dealer': 'Dealer 5'},
  ];

  void _removeDevice(int index) {
    setState(() {
      devices.removeAt(index);
    });
  }

  void _showDeleteConfirmation(int index) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Remove device?",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Are you sure you want remove this\ndevice?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => Get.back(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE1F5FE),
                          foregroundColor: AppColors.primaryBlue,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'No',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          _removeDevice(index);
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4FC3F7),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Yes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        elevation: 0,
        leading: customBackButton(context),
        title: const Text(
          'Device Preview',
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
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Repaired Device',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 15),
                devices.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: Column(
                            children: [
                              Icon(Icons.devices_other_outlined,
                                  size: 60, color: Colors.grey.shade300),
                              const SizedBox(height: 15),
                              Text(
                                "No repaired devices selected",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.all(20),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          children: List.generate(devices.length, (index) {
                            return _buildDeviceInfo(
                              devices[index]['serial']!,
                              devices[index]['dealer']!,
                              index,
                            );
                          }),
                        ),
                      ),
                const SizedBox(height: 30),
                if (devices.isNotEmpty)
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                      children: [
                        TextSpan(
                            text: 'Are you sure want to reallocate these\ndevices to '),
                        TextSpan(
                          text: 'Dealer 1',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: '?'),
                      ],
                    ),
                  ),
                const SizedBox(height: 100), // Space for bottom buttons
              ],
            ),
          ),
          if (devices.isNotEmpty)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.all(20),
                color: AppColors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () => Get.back(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE1F5FE),
                            foregroundColor: AppColors.primaryBlue,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'No',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: SizedBox(
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(() => const AllocationSuccessView());
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
                            'Yes',
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

  Widget _buildDeviceInfo(String serial, String dealer, int index) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    serial,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                  Text(
                    ':  $dealer',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF444444),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(Icons.delete_outline, color: Colors.red, size: 22),
              onPressed: () => _showDeleteConfirmation(index),
            ),
          ],
        ),
        if (index != devices.length - 1)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: Color(0xFFEEEEEE)),
          ),
      ],
    );
  }
}
