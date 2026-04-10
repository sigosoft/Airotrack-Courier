  import 'package:airotrack_courier/utils/app_colors.dart';
import 'package:flutter/material.dart';

IconButton customBackButton(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
        onPressed: () => Navigator.pop(context),
      );
      
  }