import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mrwah/app/core/resources/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBackButton, centerTitle;
  final bool showLogo;
  final VoidCallback? onBackPressed;
  final Color? color, iconColor;
  final List<Widget>? actions;

  const CustomAppBar(
      {super.key,
      this.title,
      this.showBackButton = false,
      this.showLogo = false,
      this.centerTitle = false,
      this.onBackPressed,
      this.color,
      this.actions,
      this.iconColor = AppColors.kGold});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: color ?? Colors.transparent,
      elevation: 0,
      centerTitle: centerTitle,
      automaticallyImplyLeading: false,
      leadingWidth: 28,
      leading: showBackButton
          ? Padding(
              padding: const EdgeInsets.only(left: 8),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: iconColor),
                onPressed: onBackPressed ?? () => Navigator.pop(context),
              ),
            )
          : null,
      title: Text(
        title ?? '',
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
          color: iconColor ?? AppColors.mainColor,
        ),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.h);
}
