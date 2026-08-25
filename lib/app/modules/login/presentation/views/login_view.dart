import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mrwah/app/core/helpers/extensions.dart';
import 'package:mrwah/app/core/resources/app_colors.dart';
import 'package:mrwah/app/core/widgets/app_button.dart';
import 'package:mrwah/app/modules/on_boarding/views/components/partner_web_view.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.kDarkBlue,
      body: Form(
        key: controller.formKey,
        child: Stack(
          children: [
            // Background decorations
            Positioned(
              top: -height * 0.15,
              left: -width * 0.2,
              child: _circleAccent(width, AppColors.mainColor, 0.8),
            ),
            Positioned(
              bottom: -height * 0.15,
              right: -width * 0.2,
              child: _circleAccent(
                  width, AppColors.mainColor.applyOpacity(0.18), 0.8),
            ),

            // Animated content
            Align(
              alignment: Alignment.center,
              child: SlideTransition(
                position: controller.slideAnimation,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _welcomeCard(),
                      _formCard(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
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

  Widget _welcomeCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 22),
      decoration: BoxDecoration(
        color: AppColors.kDarkBlue.applyOpacity(0.97),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(22),
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.bgColor.applyOpacity(0.10),
            blurRadius: 30,
            offset: const Offset(0, 16),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 48, 32, 34),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.mainColor,
              radius: 45,
              child: Image.asset(
                'assets/images/mrwh_logo.png',
                width: 45,
                height: 45,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'welcome_back'.tr,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _formCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 22),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
          bottomLeft: Radius.circular(44),
          bottomRight: Radius.circular(44),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            offset: Offset(0, 8),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label('email_address'.tr),
            TextFormField(
              controller: controller.emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: _inputDecoration('enter_email'.tr),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'field_required'.tr
                  : null,
            ),
            const SizedBox(height: 18),
            _label("password".tr),
            Obx(() => TextFormField(
                  controller: controller.passwordController,
                  obscureText: controller.isPasswordHidden.value,
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'field_required'.tr
                      : null,
                  decoration: _inputDecoration("enter_password".tr).copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isPasswordHidden.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.bgColor,
                      ),
                      onPressed: controller.togglePasswordVisibility,
                    ),
                  ),
                )),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => Row(
                      children: [
                        Checkbox(
                          value: controller.rememberMe.value,
                          onChanged: (_) => controller.toggleRememberMe(),
                          activeColor: AppColors.mainColor,
                        ),
                        Text(
                          "remember_me".tr,
                          style: TextStyle(
                            color: AppColors.kDarkBlue.applyOpacity(0.82),
                          ),
                        ),
                      ],
                    )),
                TextButton(
                  onPressed: controller.goToResetPassword,
                  child: Text(
                    "forgot_password".tr,
                    style: TextStyle(
                      color: AppColors.kDarkBlue.applyOpacity(0.80),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 22),
            Obx(
              () => AppButton(
                text: 'login'.tr,
                isLoading: controller.isLoading.value,
                onPressed: controller.login,
              ),
            ),
            const SizedBox(height: 20),
            Row(children: [
              const Expanded(child: Divider(color: Color(0xFFE0E0E0))),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  "or".tr,
                  style: const TextStyle(
                      color: AppColors.kGold, fontWeight: FontWeight.bold),
                ),
              ),
              const Expanded(child: Divider(color: Color(0xFFE0E0E0))),
            ]),
            const SizedBox(height: 12),
            Center(
              child: Text.rich(
                TextSpan(
                  text: "dont_have_account".tr,
                  style: TextStyle(
                    color: AppColors.kDarkBlue.applyOpacity(0.85),
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    TextSpan(
                      text: "sign_up".tr,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.mainColor),
                      recognizer: TapGestureRecognizer()
                        ..onTap = controller.goToSignUp,
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            GestureDetector(
              onTap: () => Get.to(() => const PartnerWebView(
                    url: 'https://mrwah.org/admin',
                  )),
              child: Center(
                child: Text.rich(
                  TextSpan(
                    text: "login_as".tr,
                    style: TextStyle(
                      color: AppColors.kDarkBlue.applyOpacity(0.85),
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      TextSpan(
                        text: "partner".tr,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.mainColor),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Text(
        text,
        style: TextStyle(
          color: AppColors.kDarkBlue.applyOpacity(0.85),
          fontWeight: FontWeight.w500,
        ),
      );

  InputDecoration _inputDecoration(String hint) => InputDecoration(
        hintText: hint,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.mainColor, width: 1.2),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.mainColor, width: 2),
        ),
      );
}
