import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class CustomLoadingIndicator extends StatelessWidget {
  final Color color;
  const CustomLoadingIndicator({super.key, this.color = AppColors.primaryBlue});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}
