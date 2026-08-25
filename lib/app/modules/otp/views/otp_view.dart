import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mrwah/app/core/widgets/app_button.dart';
import 'package:mrwah/app/core/widgets/brand_footer.dart';
import 'package:mrwah/app/core/widgets/loading_overlay_widget.dart';
import 'package:pinput/pinput.dart';
import 'package:mrwah/app/core/helpers/extensions.dart';
import 'package:mrwah/app/core/resources/app_colors.dart';
import '../controllers/otp_controller.dart';

class OtpView extends GetView<OtpController> {
  const OtpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkBlue,
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: FadeTransition(
              opacity: controller.fadeAnimation,
              child: SlideTransition(
                position: controller.slideAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _header(),
                    const SizedBox(height: 40),
                    _otpCard(context),
                  ],
                ),
              ),
            ),
          ),
          Obx(() {
            if (!controller.isLoading.value) {
              return const SizedBox.shrink();
            }

            return const LoadingOverlay(
              text: 'Creating account...',
            );
          }),
        ],
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Icon(
                Icons.arrow_back_ios,
                color: AppColors.mainColor,
                size: 24,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Verify OTP',
                style: TextStyle(
                  color: AppColors.mainColor,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Enter the 4-digit code sent to you',
                style: TextStyle(
                  color: AppColors.kGold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _otpCard(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 80,
      height: 55,
      textStyle: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.mainColor.applyOpacity(0.3),
        ),
      ),
    );

    return Expanded(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Text(
              "Enter the verification code sent to ${controller.maskedPhone} :",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 30),
            Pinput(
              length: controller.otpLength,
              controller: controller.otpController,
              separatorBuilder: (index) => const SizedBox(width: 5),
              autofocus: true,
              keyboardType: TextInputType.number,
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  border: Border.all(
                    color: AppColors.mainColor,
                    width: 2,
                  ),
                ),
              ),
              submittedPinTheme: defaultPinTheme,
              onChanged: (value) {
                controller.otpCode.value = value;
              },
              onCompleted: (value) {
                controller.otpCode.value = value;
              },
            ),
            const SizedBox(height: 45),
            Obx(
              () => AppButton(
                text: 'Verfiy',
                backgroundColor: AppColors.mainColor,
                isLoading: controller.isLoading.value,
                onPressed: controller.submitOtp,
              ),
            ),
            const SizedBox(height: 16),
            Obx(() {
              if (controller.canResend.value) {
                return TextButton(
                  onPressed: controller.resendOtp,
                  child: Text(
                    "Resend Code",
                    style: TextStyle(
                      color: AppColors.mainColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }

              return Text(
                "Resend in ${controller.resendSeconds.value}s",
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              );
            }),
            const Spacer(),
            const BrandFooter(),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
