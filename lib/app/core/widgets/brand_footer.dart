import 'package:flutter/material.dart';
import 'package:mrwah/app/core/resources/app_colors.dart';

class BrandFooter extends StatelessWidget {
  const BrandFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 6,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6, left: 4),
          child: Image.asset(
            'assets/images/mrwh_logo.png',
            width: 45,
            height: 45,
            color: AppColors.mainColor,
          ),
        ),
        Text(
          'Mrwah',
          style: TextStyle(
            color: AppColors.mainColor,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
