import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const CustomAppBar({super.key, this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;

    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: AppColors.black),
        onPressed: () {
          if (scaffoldKey != null) {
            scaffoldKey!.currentState?.openDrawer();
          }
        },
      ),     
      centerTitle: true,
      title: Image.asset(
        'lib/assets/images/applogo.png',
        width: width * 0.25, // Using mediaquery as requested
        height: height * 0.10,
        fit: BoxFit.contain,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
