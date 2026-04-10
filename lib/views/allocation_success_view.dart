import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/app_colors.dart';
import 'invoice_view.dart';

class AllocationSuccessView extends StatefulWidget {
  const AllocationSuccessView({super.key});

  @override
  State<AllocationSuccessView> createState() => _AllocationSuccessViewState();
}

class _AllocationSuccessViewState extends State<AllocationSuccessView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Media query for responsive design
    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height;
    final width = mediaQuery.size.width;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.08),
          child: Column(
            children: [
              const Spacer(flex: 3),
              // Concentric circles success icon with animation
              Center(
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        // Outer circle (Large pulse)
                        Transform.scale(
                          scale: 1.0 + (_animation.value - 1.0) * 1.5,
                          child: Container(
                            height: width * 0.55,
                            width: width * 0.55,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFE3F2FD), // Very light blue
                            ),
                          ),
                        ),
                        // Middle circle (Medium pulse)
                        Transform.scale(
                          scale: 1.0 + (_animation.value - 1.0) * 0.8,
                          child: Container(
                            height: width * 0.42,
                            width: width * 0.42,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFBBDEFB), // Light blue
                            ),
                          ),
                        ),
                        
                        // Inner circle (Slight pulse)
                        Transform.scale(
                          scale: 1.0 + (_animation.value - 1.0) * 0.3,
                          child: Container(
                            height: width * 0.3,
                            width: width * 0.3,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primaryBlue, // Actual blue
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 75,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: height * 0.06),
              // Success message
              const Text(
                'Device allocated successfully',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const Spacer(flex: 4),
              // Download Invoice button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(() => const InvoiceView());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4FC3F7), // Match provided image color
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Download Invoice',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: height * 0.04),
            ],
          ),
        ),
      ),
    );
  }
}
