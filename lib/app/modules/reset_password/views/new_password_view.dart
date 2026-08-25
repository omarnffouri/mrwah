import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mrwah/app/core/helpers/extensions.dart';
import 'package:mrwah/app/core/resources/app_colors.dart';
import 'package:mrwah/app/core/widgets/app_button.dart';

import '../controllers/new_password_controller.dart';

class NewPasswordView extends GetView<NewPasswordController> {
  const NewPasswordView({super.key});

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
              'create_new_password'.tr,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'set_new_password_description'.tr,
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
              Icons.password_rounded,
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
            'reset_password_subtitle'.tr,
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
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label('new_password'.tr),
            const SizedBox(height: 8),
            Obx(
              () => TextFormField(
                controller: controller.newPasswordController,
                obscureText: controller.isNewPasswordHidden.value,
                validator: controller.validateNewPassword,
                decoration: _passwordDecoration(
                  'enter_password'.tr,
                  controller.isNewPasswordHidden.value,
                  controller.toggleNewPasswordVisibility,
                ),
              ),
            ),
            const SizedBox(height: 18),
            _label('confirm_new_password'.tr),
            const SizedBox(height: 8),
            Obx(
              () => TextFormField(
                controller: controller.confirmPasswordController,
                obscureText: controller.isConfirmPasswordHidden.value,
                validator: controller.validateConfirmPassword,
                decoration: _passwordDecoration(
                  'confirm_password'.tr,
                  controller.isConfirmPasswordHidden.value,
                  controller.toggleConfirmPasswordVisibility,
                ),
              ),
            ),
            const SizedBox(height: 22),
            Obx(
              () => AppButton(
                text: 'save_new_password'.tr,
                backgroundColor: AppColors.mainColor,
                isLoading: controller.isLoading.value,
                onPressed: controller.saveNewPassword,
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text.rich(
                TextSpan(
                  text: "back_to_login".tr,
                  style: TextStyle(
                    color: AppColors.kDarkBlue.applyOpacity(0.78),
                    fontWeight: FontWeight.w500,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = Get.back,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: TextStyle(
        color: AppColors.kDarkBlue.applyOpacity(0.85),
        fontWeight: FontWeight.w500,
      ),
    );
  }

  InputDecoration _passwordDecoration(
    String hint,
    bool isHidden,
    VoidCallback onToggle,
  ) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xfff9fafc),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      suffixIcon: IconButton(
        icon: Icon(
          isHidden ? Icons.visibility_off : Icons.visibility,
          color: AppColors.bgColor,
        ),
        onPressed: onToggle,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: AppColors.mainColor.applyOpacity(0.35),
          width: 1.2,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: AppColors.mainColor,
          width: 1.4,
        ),
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
