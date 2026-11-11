import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../bindings/home_binding.dart';
import '../controllers/home_controller.dart';
import '../models/invoice_data.dart';
import '../utils/app_colors.dart';
import '../utils/invoice_pdf.dart';
import 'home_view.dart';

/// Invoice for the allocation that just succeeded, built from the courier
/// request and the allocated device counts.
class InvoiceView extends StatelessWidget {
  final InvoiceData data;

  const InvoiceView({super.key, required this.data});

  static const _dark = Color(0xFF444444);

  @override
  Widget build(BuildContext context) {
    final label = const TextStyle(color: Colors.grey, fontSize: 13);
    final value = const TextStyle(fontWeight: FontWeight.bold);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        // Dark icon: the shared back button is white and vanishes on this
        // white app bar.
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Invoice',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Text(
                      'INVOICE',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: _dark,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Divider(thickness: 1),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Invoice No:', style: label),
                          Text('#${data.invoiceNumber}', style: value),
                          const SizedBox(height: 15),
                          Text('Date issued:', style: label),
                          Text(data.formattedDate, style: value),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Issued to:', style: label),
                          Text(data.issuedToName, style: value),
                          Text(
                            data.issuedToRole,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                _buildTable(),
                if (data.allocatedBy.isNotEmpty) ...[
                  const SizedBox(height: 30),
                  Text('Allocated by:', style: label),
                  Text(
                    data.allocatedBy,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
                const SizedBox(height: 170), // room for the floating buttons
              ],
            ),
          ),
          Positioned(
            bottom: 25,
            left: 25,
            right: 25,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    tooltip: 'Share invoice',
                    icon: const Icon(
                      Icons.share,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () => InvoicePdf.share(data),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      if (Get.isRegistered<HomeController>()) {
                        Get.find<HomeController>().resetAll();
                      }
                      Get.offAll(
                        () => const HomeView(),
                        binding: HomeBinding(),
                      );
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
                      'Go to Main Menu',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTable() {
    const head = TextStyle(fontSize: 10, fontWeight: FontWeight.bold);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Container(
            color: const Color(0xFFE5DDD5),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            child: const Row(
              children: [
                SizedBox(width: 30, child: Text('NO', style: head)),
                Expanded(child: Text('DESCRIPTION', style: head)),
                SizedBox(
                  width: 50,
                  child: Text('QTY', textAlign: TextAlign.center, style: head),
                ),
              ],
            ),
          ),
          if (data.lines.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('No devices', style: TextStyle(color: Colors.grey)),
            ),
          for (var i = 0; i < data.lines.length; i++) ...[
            if (i > 0) const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              child: Row(
                children: [
                  SizedBox(
                    width: 30,
                    child: Text(
                      '${i + 1}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      data.lines[i].description,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 50,
                    child: Text(
                      '${data.lines[i].quantity}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
          Container(
            color: const Color(0xFFB9B2AA),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'TOTAL DEVICES',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: Text(
                    '${data.totalQuantity}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
