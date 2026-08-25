import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mrwah/app/core/resources/app_colors.dart';

class CustomHeader extends StatelessWidget {
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;
  final Color? color;

  const CustomHeader({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.actions,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            if (showBackButton)
              GestureDetector(
                onTap: () => Get.back(),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: color ?? AppColors.mainColor,
                  size: 22,
                ),
              ),
            if (showBackButton) const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color ?? AppColors.mainColor,
              ),
            ),
            const Spacer(),
            ...?actions,
          ],
        ),
      ),
    );
  }
}
