import 'package:airotrack_courier/utils/app_colors.dart';
import 'package:flutter/material.dart';

Widget buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          content,
          textAlign: TextAlign.justify,
          style: const TextStyle(
            fontSize: 15,
            height: 1.5,
            color: AppColors.black,
          ),
        ),
      ],
    );
  }