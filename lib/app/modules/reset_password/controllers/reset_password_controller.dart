import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mrwah/app/core/widgets/app_snack_bar.dart';
import 'package:mrwah/app/routes/app_pages.dart';
import 'package:mrwah/app/services/injection_service.dart';
import 'package:mrwah/app/modules/reset_password/domain/usecases/send_reset_email_usecase.dart';

class ResetPasswordController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final isLoading = false.obs;
  final sendResetEmailUseCase = sl<SendResetEmailUseCase>();

  late AnimationController animationController;
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;

  @override
  void onInit() {
    super.onInit();

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
  }

  Future<void> sendResetCode() async {
    if (formKey.currentState?.validate() != true) return;

    try {
      isLoading.value = true;

      final email = emailController.text.trim();

      final result = await sendResetEmailUseCase(email);

      result.fold((message) {
        AppSnackBar.success(
          message,
          title: "reset_password_title".tr,
        );

        Get.toNamed(
          Routes.RESET_PASSWORD_CODE,
          arguments: {'email': email},
        );
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
    emailController.dispose();
    super.onClose();
  }
}
