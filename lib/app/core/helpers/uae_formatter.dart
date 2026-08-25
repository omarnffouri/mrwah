import 'package:flutter/services.dart';

class UaePhoneInputFormatter extends TextInputFormatter {
  static final _regex = RegExp(r'^5\d{0,8}$');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    // ✅ Always allow empty (backspace)
    if (text.isEmpty) {
      return newValue;
    }

    // ❌ Reject anything that doesn't match
    if (!_regex.hasMatch(text)) {
      return oldValue;
    }

    return newValue;
  }
}

String? uaePhoneValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Phone number is required';
  }

  if (!RegExp(r'^5\d{8}$').hasMatch(value)) {
    return 'Enter a valid UAE mobile number';
  }

  return null;
}
