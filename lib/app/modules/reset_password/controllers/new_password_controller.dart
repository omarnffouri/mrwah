import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mrwah/app/core/widgets/app_snack_bar.dart';
import 'package:mrwah/app/modules/reset_password/domain/usecases/reset_password_usecase.dart';
import 'package:mrwah/app/routes/app_pages.dart';
import 'package:mrwah/app/services/injection_service.dart';

class NewPasswordController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final isLoading = false.obs;
  final isNewPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;
  final resetPasswordUseCase = sl<ResetPasswordUseCase>();

  late final String email;
  late final String token;

  late AnimationController animationController;
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments as Map<String, dynamic>? ?? {};
    email = args['email'] ?? '';
    token = args['token'] ?? '';

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    fadeAnimation =
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut);

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    animationController.forward();

    if (email.isEmpty || token.isEmpty) {
      AppSnackBar.error('reset_password_data_missing'.tr);
      Future.microtask(() => Get.offAllNamed(Routes.RESET_PASSWORD));
    }
  }

  String? validateNewPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'field_required'.tr;
    }
    if (value.trim().length < 6) {
      return 'password_min_length'.trParams({'min': '6'});
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'field_required'.tr;
    }
    if (value.trim() != newPasswordController.text.trim()) {
      return 'passwords_not_match'.tr;
    }
    return null;
  }

  void toggleNewPasswordVisibility() =>
      isNewPasswordHidden.value = !isNewPasswordHidden.value;

  void toggleConfirmPasswordVisibility() =>
      isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;

  Future<void> saveNewPassword() async {
    if (formKey.currentState?.validate() != true) return;

    try {
      isLoading.value = true;

      final result = await resetPasswordUseCase(
        token: token,
        email: email,
        password: newPasswordController.text.trim(),
        passwordConfirmation: confirmPasswordController.text.trim(),
      );

      result.fold((message) {
        AppSnackBar.success(
          message,
          title: "reset_password_title".tr,
        );

        Get.offAllNamed(Routes.LOGIN);
      }, (failure) {
        AppSnackBar.error(failure.message);
      });
    } catch (e) {
      AppSnackBar.error(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    animationController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
