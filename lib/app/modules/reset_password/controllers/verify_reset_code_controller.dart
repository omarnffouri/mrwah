import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mrwah/app/core/widgets/app_snack_bar.dart';
import 'package:mrwah/app/modules/reset_password/domain/usecases/send_reset_email_usecase.dart';
import 'package:mrwah/app/modules/reset_password/domain/usecases/verify_reset_code_usecase.dart';
import 'package:mrwah/app/routes/app_pages.dart';
import 'package:mrwah/app/services/injection_service.dart';

class VerifyResetCodeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final int otpLength = 6;
  final otpCode = ''.obs;
  final isLoading = false.obs;
  final TextEditingController otpController = TextEditingController();

  late final String email;

  late AnimationController animationController;
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;

  final verifyResetCodeUseCase = sl<VerifyResetCodeUseCase>();
  final sendResetEmailUseCase = sl<SendResetEmailUseCase>();

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments as Map<String, dynamic>? ?? {};
    email = args['email'] ?? '';

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

    if (email.isEmpty) {
      AppSnackBar.error('reset_password_data_missing'.tr);
      Future.microtask(() => Get.offAllNamed(Routes.RESET_PASSWORD));
    }
  }

  Future<void> submitCode() async {
    if (otpCode.value.length < otpLength) {
      AppSnackBar.info('enter_full_code'.tr);
      return;
    }

    try {
      isLoading.value = true;

      final result = await verifyResetCodeUseCase(
        email: email,
        code: otpCode.value,
      );

      result.fold((message) {
        AppSnackBar.success(
          message,
          title: "reset_password_title".tr,
        );

        Get.toNamed(
          Routes.NEW_PASSWORD,
          arguments: {
            'email': email,
            'token': otpCode.value,
          },
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

  Future<void> resendCode() async {
    if (email.isEmpty) return;

    try {
      isLoading.value = true;

      final result = await sendResetEmailUseCase(email);

      result.fold((message) {
        AppSnackBar.success(
          message,
          title: "check_inbox".tr,
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
    otpController.dispose();
    animationController.dispose();
    super.onClose();
  }
}
