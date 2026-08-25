import 'package:get/get.dart';

class InputValidators {
  static String? password(String? value, {int minLength = 6}) {
    if (value == null || value.isEmpty) {
      return 'password_required'.tr;
    } else if (value.length < minLength) {
      return 'password_min_length'.trParams({'min': '$minLength'});
    }
    return null;
  }

  static String? email(String? value) {
    final regex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    if (value == null || value.trim().isEmpty) {
      return 'email_required'.tr;
    } else if (!regex.hasMatch(value.trim())) {
      return 'email_invalid'.tr;
    }
    return null;
  }

  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      // Use GetX's trParams for parameters
      return 'field_required'.trParams({
        'field': fieldName ?? 'this_field'.tr,
      });
    }
    return null;
  }
}
