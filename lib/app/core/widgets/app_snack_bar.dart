import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mrwah/app/core/resources/app_colors.dart';

class AppSnackBar {
  static void success(String message, {String title = "Success"}) {
    _show(
      title: title,
      message: message,
      textColor: AppColors.kDarkBlue,
      backgroundColor: AppColors.mainColor,
    );
  }

  static void error(String message, {String title = "Failed"}) {
    _show(
      title: title,
      message: message,
      backgroundColor: Colors.redAccent,
    );
  }

  static void info(String message, {String title = "Info"}) {
    _show(
      title: title,
      message: message,
      backgroundColor: Colors.blueGrey,
    );
  }

  static void _show({
    required String title,
    required String message,
    Color? textColor,
    required Color backgroundColor,
  }) {
    Get.snackbar(
      title,
      message,
      backgroundColor: backgroundColor,
      colorText: textColor ?? Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
    );
  }
}
