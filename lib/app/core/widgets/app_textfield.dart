import 'package:flutter/material.dart';
import 'package:mrwah/app/core/helpers/extensions.dart';
import 'package:mrwah/app/core/resources/app_colors.dart';

class AppTextField extends StatelessWidget {
  final String? label;
  final String? hintText;
  final IconData? icon;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool readOnly;
  final VoidCallback? onTap;
  final bool obscureText;
  final bool filled;

  const AppTextField({
    super.key,
    this.label,
    this.hintText,
    this.icon,
    this.controller,
    this.keyboardType,
    this.validator,
    this.readOnly = false,
    this.onTap,
    this.obscureText = false,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      readOnly: readOnly,
      onTap: onTap,
      obscureText: obscureText,
      decoration: InputDecoration(
          filled: filled,
          fillColor: filled == true ? Colors.white : null,
          prefixIcon:
              icon != null ? Icon(icon, color: AppColors.mainColor) : null,
          labelText: label,
          hintText: hintText,
          hintStyle: TextStyle(color: AppColors.kDarkBlue.applyOpacity(0.34)),
          labelStyle: TextStyle(color: AppColors.bgColor),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: AppColors.mainColor, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: AppColors.mainColor, width: 2.2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.red),
          )),
    );
  }
}
