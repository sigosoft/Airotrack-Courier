import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/app_colors.dart';
import 'home_view.dart';
import '../controllers/home_controller.dart';
import '../widgets/custom_back_button.dart';
import '../bindings/home_binding.dart';

class InvoiceView extends StatelessWidget {
  const InvoiceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: customBackButton(context),
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
                        color: Color(0xFF444444),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Invoice No:',
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                        Text(
                          '#123456',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 15),
                        Text(
                          'Date issued:',
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                        Text(
                          '01 April 2022',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Issued to:',
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                        const Text(
                          'Alfredo Torres',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '123 Anywhere St.,\nAny City, ST 12345',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                // Styled Invoice Table
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    children: [
                      // Header
                      Container(
                        color: const Color(0xFFE5DDD5), // Beige/Grey color
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 10,
                        ),
                        child: const Row(
                          children: [
                            SizedBox(
                              width: 30,
                              child: Text(
                                'NO',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'DESCRIPTION',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 40,
                              child: Text(
                                'QTY',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 60,
                              child: Text(
                                'PRICE',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 60,
                              child: Text(
                                'SUBTOTAL',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildInvoiceRow(
                        '1',
                        'Social Media Post',
                        '20',
                        '\$ 100',
                        '\$ 2000',
                      ),
                      const Divider(height: 1),
                      _buildInvoiceRow(
                        '2',
                        'Copywriting',
                        '5',
                        '\$ 50',
                        '\$ 250',
                      ),
                      const SizedBox(height: 100), // Filler space for the table
                      // Footer (Grand Total)
                      Container(
                        color: const Color(0xFFB9B2AA), // Darker grey for total
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 10,
                        ),
                        child: const Row(
                          children: [
                            Expanded(
                              child: Text(
                                'GRAND TOTAL',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            SizedBox(width: 20),
                            SizedBox(
                              width: 60,
                              child: Text(
                                '\$ 2250',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Payment Information',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const Text(
                  'Bank Name: Fauget',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const Text(
                  'Account No: 122-456-7890',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 40),
                // Signature area
                Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    children: [
                      const Text(
                        'Claudia',
                        style: TextStyle(
                          fontFamily:
                              'Cursive', // You'll need a cursive font if available
                          fontSize: 28,
                          color: Color(0xFF444444),
                        ),
                      ),
                      Container(
                        width: 120,
                        height: 1,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Finance Manager',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 120), // Spacing for floating buttons
              ],
            ),
          ),
          // Floating Share and Go to Main Menu button
          Positioned(
            bottom: 25,
            left: 25,
            right: 25,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Share button
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.share,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () {
                        // Handle share invoice
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Go to Main Menu button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.delete<HomeController>(force: true);
                      Get.offAll(() => const HomeView(), binding: HomeBinding());
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

  Widget _buildInvoiceRow(
    String no,
    String desc,
    String qty,
    String price,
    String subtotal,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 30,
            child: Text(no, style: const TextStyle(fontSize: 10)),
          ),
          Expanded(
            child: Text(
              desc,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: 40,
            child: Text(
              qty,
              style: const TextStyle(fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 60,
            child: Text(
              price,
              style: const TextStyle(fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 60,
            child: Text(
              subtotal,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
