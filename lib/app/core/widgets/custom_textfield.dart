import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mrwah/app/core/resources/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final IconData? prefixIcon;
  final Widget? prefixWidget;

  final Color? borderColor, hintColor, textColor;
  final bool obscureText;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool filled;

  const CustomTextField({
    super.key,
    this.controller,
    required this.hintText,
    this.onChanged,
    this.prefixIcon,
    this.prefixWidget, // ✅ NEW
    this.borderColor,
    this.hintColor,
    this.obscureText = false,
    this.validator,
    this.textColor = AppColors.kDarkBlue,
    this.keyboardType,
    this.inputFormatters,
    this.filled = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      onChanged: widget.onChanged,
      validator: widget.validator,
      obscureText: _obscure,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      style: TextStyle(color: widget.textColor),
      decoration: InputDecoration(
          filled: widget.filled,
          fillColor: widget.filled == true ? Colors.white : null,
          hintText: widget.hintText,
          hintStyle: TextStyle(color: widget.hintColor),
          prefixIcon: widget.prefixWidget ??
              (widget.prefixIcon != null
                  ? Icon(widget.prefixIcon, color: AppColors.mainColor)
                  : null),
          suffixIcon: widget.obscureText
              ? IconButton(
                  icon: Icon(
                    _obscure ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.mainColor,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscure = !_obscure;
                    });
                  },
                )
              : null,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: widget.borderColor ?? AppColors.mainColor,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: widget.borderColor ?? AppColors.mainColor,
              width: 2.0,
            ),
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
