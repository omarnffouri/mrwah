import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mrwah/app/services/storage_service.dart';

class LanguagesController extends GetxController {
  // Supported languages (add as many as you want)
  final languages = [
    {'name': 'english', 'code': 'en'},
    {'name': 'arabic', 'code': 'ar'},
  ];

  // Current selected language code
  RxString selectedLanguage = 'en'.obs;

  @override
  void onInit() {
    super.onInit();
    selectedLanguage.value = StorageService.langCode;
  }

  void changeLanguage(String code) {
    selectedLanguage.value = code;
    StorageService.langCode = code;
    Get.updateLocale(Locale(code));
  }
}
