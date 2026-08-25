import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mrwah/app/core/helpers/extensions.dart';
import 'package:mrwah/app/core/resources/app_colors.dart';
import 'package:mrwah/app/core/widgets/app_button.dart';
import 'package:mrwah/app/core/widgets/brand_footer.dart';
import 'package:pinput/pinput.dart';

import '../controllers/verify_reset_code_controller.dart';

class VerifyResetCodeView extends GetView<VerifyResetCodeController> {
  const VerifyResetCodeView({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.kDarkBlue,
      body: Stack(
        children: [
          Positioned(
            top: -height * 0.15,
            left: -width * 0.2,
            child: _circleAccent(width, AppColors.mainColor, 1),
          ),
          Positioned(
            bottom: -height * 0.15,
            right: -width * 0.2,
            child: _circleAccent(
              width,
              AppColors.mainColor.applyOpacity(0.16),
              1,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: FadeTransition(
              opacity: controller.fadeAnimation,
              child: SlideTransition(
                position: controller.slideAnimation,
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 26),
                  child: Column(
                    children: [
                      _header(context),
                      const SizedBox(height: 20),
                      _infoCard(),
                      const SizedBox(height: 18),
                      _formCard(context),
                      const SizedBox(height: 14),
                      const BrandFooter(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon:
              Icon(Icons.arrow_back_ios, color: Colors.white.withOpacity(0.9)),
          onPressed: () => Get.back(),
        ),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'verify_code'.tr,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'enter_code_description'.tr,
              style: TextStyle(
                color: Colors.white.withOpacity(0.86),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _infoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 22),
      decoration: BoxDecoration(
        color: AppColors.kDarkBlue.applyOpacity(0.98),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(34),
          topRight: Radius.circular(22),
          bottomLeft: Radius.circular(34),
          bottomRight: Radius.circular(34),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.bgColor.applyOpacity(0.12),
            blurRadius: 32,
            offset: const Offset(0, 18),
          )
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 38,
            backgroundColor: AppColors.mainColor,
            child: const Icon(
              Icons.mark_email_unread_rounded,
              color: Colors.white,
              size: 36,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'reset_password_title'.tr,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'code_sent_to_email'
                .trParams({'email': controller.email}),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _formCard(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 58,
      textStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        color: const Color(0xfff9fafc),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.mainColor.applyOpacity(0.25),
          width: 1.2,
        ),
      ),
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            offset: Offset(0, 8),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'verification_code'.tr,
            style: TextStyle(
              color: AppColors.kDarkBlue.applyOpacity(0.85),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          Center(
            child: Pinput(
              length: controller.otpLength,
              controller: controller.otpController,
              separatorBuilder: (index) => const SizedBox(width: 10),
              autofocus: true,
              keyboardType: TextInputType.number,
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  border: Border.all(
                    color: AppColors.mainColor,
                    width: 1.6,
                  ),
                ),
              ),
              submittedPinTheme: defaultPinTheme,
              onChanged: (value) => controller.otpCode.value = value,
              onCompleted: (value) => controller.otpCode.value = value,
            ),
          ),
          const SizedBox(height: 24),
          Obx(
            () => AppButton(
              text: 'verify_code'.tr,
              backgroundColor: AppColors.mainColor,
              isLoading: controller.isLoading.value,
              onPressed: controller.submitCode,
            ),
          ),
          const SizedBox(height: 12),
          Obx(
            () => Center(
              child: TextButton(
                onPressed:
                    controller.isLoading.value ? null : controller.resendCode,
                child: Text(
                  'resend_code'.tr,
                  style: TextStyle(
                    color: AppColors.kDarkBlue.applyOpacity(0.85),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleAccent(double width, Color color, double sizeFactor) {
    return Container(
      width: width * sizeFactor,
      height: width * sizeFactor,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}
