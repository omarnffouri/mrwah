import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mrwah/app/core/enums/register_loading_enum.dart';
import 'package:mrwah/app/core/helpers/uae_formatter.dart';
import 'package:mrwah/app/core/resources/app_colors.dart';
import 'package:mrwah/app/core/widgets/custom_textfield.dart';
import 'package:mrwah/app/core/widgets/loading_overlay_widget.dart';
import '../controllers/register_stepper_controller.dart';

class RegisterStepperView extends GetView<RegisterStepperController> {
  const RegisterStepperView({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.kDarkBlue,
      body: Stack(
        children: [
          // Background circles
          Positioned(
            top: -height * 0.15,
            left: -width * 0.2,
            child: _circleAccent(width, AppColors.mainColor, 0.8),
          ),
          Positioned(
            bottom: -height * 0.15,
            right: -width * 0.2,
            child: _circleAccent(
                width, AppColors.mainColor.withOpacity(0.18), 0.8),
          ),

          // Main content inside white card
          Align(
            alignment: Alignment.center,
            child: SlideTransition(
              position: controller.slideAnimation,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.07, vertical: 24),
                child: Obx(() {
                  final stepIndex = controller.step.value;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 18,
                              offset: Offset(0, 6),
                            )
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 32),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/images/mrwh_logo.png',
                                    width: 38,
                                    height: 38,
                                    color: AppColors.mainColor,
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  Text(
                                    "Mrwah",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.mainColor),
                                  )
                                ],
                              ),
                              const SizedBox(height: 12),
                              _stepperHeader(),
                              const SizedBox(height: 12),
                              _stepTitle(stepIndex),
                              const SizedBox(height: 18),
                              IndexedStack(
                                index: stepIndex,
                                children: [
                                  _personalInfoStep(),
                                  _privacyStep(),
                                ],
                              ),
                              const SizedBox(height: 28),
                              _buttons(),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _footer(),
                    ],
                  );
                }),
              ),
            ),
          ),

          // ************** LOADING OVERLAY **************
          Obx(() {
            if (controller.loadingState.value ==
                RegisterLoadingState.sendingOtp) {
              return const LoadingOverlay(
                text: "Sending OTP...",
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  // --- Helpers ---
  Widget _circleAccent(double width, Color color, double sizeFactor) {
    return Container(
      width: width * sizeFactor,
      height: width * sizeFactor,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _stepperHeader() {
    final int current = controller.step.value + 1;
    final int total = controller.totalSteps;
    final double progress = (controller.step.value) / (total - 1);

    return Row(
      children: [
        Text('$current / $total',
            style: TextStyle(
                color: AppColors.mainColor, fontWeight: FontWeight.w700)),
        const SizedBox(width: 12),
        Expanded(
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.black12,
            color: AppColors.mainColor,
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _stepTitle(int stepIndex) {
    if (stepIndex == 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("lets_complete_info".tr,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.kDarkBlue)),
          const SizedBox(height: 8),
          Text("and_then_hit_the_road".tr,
              style: const TextStyle(fontSize: 16, color: AppColors.kDarkBlue)),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("privacy_terms".tr,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.kDarkBlue)),
          const SizedBox(height: 8),
          Text("a_few_final_steps".tr,
              style: const TextStyle(fontSize: 16, color: AppColors.kDarkBlue)),
        ],
      );
    }
  }

  Widget _personalInfoStep() {
    return Form(
      key: controller.formKey,
      child: Column(
        children: [
          CustomTextField(
            hintText: "first_name".tr,
            controller: controller.firstName,
            prefixIcon: Icons.person,
            validator: (value) => value == null || value.trim().isEmpty
                ? 'first_name_required'.tr
                : null,
          ),
          const SizedBox(height: 12),
          CustomTextField(
            hintText: "last_name".tr,
            controller: controller.lastName,
            prefixIcon: Icons.person,
            validator: (value) => value == null || value.trim().isEmpty
                ? 'last_name_required'.tr
                : null,
          ),
          const SizedBox(height: 12),
          CustomTextField(
            hintText: "email".tr,
            controller: controller.emailController,
            prefixIcon: Icons.email,
            validator: (value) {
              if (value == null || value.isEmpty) return 'email_required'.tr;
              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!emailRegex.hasMatch(value)) return 'email_invalid'.tr;
              return null;
            },
          ),
          const SizedBox(height: 12),
          CustomTextField(
            hintText: "Phone number",
            controller: controller.phoneNumber,
            keyboardType: TextInputType.phone,
            prefixIcon: null,
            // validator: uaePhoneValidator,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              UaePhoneInputFormatter(),
            ],
            prefixWidget: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: Text(
                "+971",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.mainColor,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          CustomTextField(
            hintText: "password".tr,
            controller: controller.passwordController,
            obscureText: true,
            prefixIcon: Icons.lock,
            validator: (value) {
              if (value == null || value.isEmpty) return 'password_required'.tr;
              if (value.length < 6) {
                return 'password_short'.tr;
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          CustomTextField(
            hintText: "confirm_password".tr,
            controller: controller.confirmPasswordController,
            obscureText: true,
            prefixIcon: Icons.lock,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'confirm_password_required'.tr;
              }
              if (value != controller.passwordController.text) {
                return 'passwords_not_match'.tr;
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _privacyStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('privacy_terms'.tr,
            style: const TextStyle(
                color: AppColors.kDarkBlue, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        Obx(() => Row(
              children: [
                Checkbox(
                  value: controller.acceptPrivacy.value,
                  activeColor: AppColors.mainColor,
                  onChanged: (v) => controller.acceptPrivacy.value = v ?? false,
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text: 'i_agree_to'.tr,
                      style: const TextStyle(color: AppColors.kDarkBlue),
                      children: [
                        TextSpan(
                          text: 'privacy_policy'.tr,
                          style: TextStyle(
                              color: AppColors.mainColor,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w700),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => controller.openPrivacyPolicy(),
                        ),
                        TextSpan(text: 'and'.tr),
                        TextSpan(
                          text: 'terms_of_service'.tr,
                          style: TextStyle(
                              color: AppColors.mainColor,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w700),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => controller.openPrivacyPolicy(),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )),
      ],
    );
  }

  Widget _buttons() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: OutlinedButton(
            onPressed: controller.isFirstStep ? null : controller.back,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.mainColor),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: Text('back'.tr,
                style: TextStyle(
                    color: controller.isFirstStep
                        ? Colors.black26
                        : AppColors.mainColor)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed:
                controller.isLastStep ? controller.sendOtp : controller.next,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.mainColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: Text(controller.isLastStep ? 'submit'.tr : 'next'.tr,
                style: const TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }

  Widget _footer() {
    return Center(
      child: Text.rich(
        TextSpan(
          text: "already_have_account".tr,
          style: TextStyle(color: AppColors.mainColor),
          children: [
            TextSpan(
              text: "sign_in".tr,
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: AppColors.mainColor),
              recognizer: TapGestureRecognizer()
                ..onTap = () => Get.toNamed('/login'),
            ),
          ],
        ),
      ),
    );
  }
}
