import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mrwah/app/core/helpers/extensions.dart';
import 'package:mrwah/app/core/resources/app_colors.dart';
import 'package:mrwah/app/core/widgets/app_bar.dart';
import 'package:mrwah/app/modules/partner_program/views/partner_on_boarding.dart';
import 'package:mrwah/app/routes/app_pages.dart';
import '../controllers/select_role_controller.dart';

class SelectRoleView extends GetView<SelectRoleController> {
  const SelectRoleView({super.key});

  static const double horizontalContentPadding = 20.0;
  static const double verticalContentPadding = 32.0;

  static const Duration animDuration = Duration(milliseconds: 200);
  static const Curve animCurve = Curves.easeOut;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: AssetImage('assets/images/main_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              const CustomAppBar(
                showBackButton: true,
                iconColor: AppColors.kDarkBlue,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: horizontalContentPadding,
                    vertical: verticalContentPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),
                    Text(
                      'choose_your_role'.tr,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.bgColor,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Obx(() {
                      final isSelected =
                          controller.selectedRole.value == 'User';
                      final isHovered = controller.hoverUser.value;
                      final effectiveScale =
                          (isSelected || isHovered) ? 1.06 : 1.0;
                      final titleSize = (isSelected || isHovered) ? 26.0 : 22.0;

                      return MouseRegion(
                        onEnter: (_) => controller.hoverUser.value = true,
                        onExit: (_) => controller.hoverUser.value = false,
                        child: GestureDetector(
                          onTap: () => controller.selectedRole.value = 'User',
                          onTapDown: (_) => controller.hoverUser.value = true,
                          onTapUp: (_) => controller.hoverUser.value = false,
                          onTapCancel: () => controller.hoverUser.value = false,
                          child: AnimatedScale(
                            scale: effectiveScale,
                            duration: animDuration,
                            curve: animCurve,
                            child: Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(top: 36),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.bgColor
                                      : AppColors.mainColor.applyOpacity(0.9),
                                  width: 2,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: SizedBox(
                                  height: 160,
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Image.asset(
                                        'assets/images/owner.jpeg',
                                        fit: BoxFit.cover,
                                      ),

                                      Container(
                                        color: Colors.black.applyOpacity(
                                            isSelected ? 0.45 : 0.35),
                                      ),
                                      // Animated text size
                                      Center(
                                        child: AnimatedDefaultTextStyle(
                                          duration: animDuration,
                                          curve: animCurve,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: titleSize,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 22, vertical: 6),
                                            decoration: BoxDecoration(
                                                color: AppColors.mainColor
                                                    .applyOpacity(0.8),
                                                borderRadius:
                                                    BorderRadius.circular(16)),
                                            child: Text('user'.tr),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 32),
                    Obx(() {
                      final isSelected =
                          controller.selectedRole.value == 'Partner';
                      final isHovered = controller.hoverPartner.value;
                      final effectiveScale =
                          (isSelected || isHovered) ? 1.06 : 1.0;
                      final titleSize = (isSelected || isHovered) ? 26.0 : 22.0;

                      return MouseRegion(
                        onEnter: (_) => controller.hoverPartner.value = true,
                        onExit: (_) => controller.hoverPartner.value = false,
                        child: GestureDetector(
                          onTap: () =>
                              controller.selectedRole.value = 'Partner',
                          onTapDown: (_) =>
                              controller.hoverPartner.value = true,
                          onTapUp: (_) => controller.hoverPartner.value = false,
                          onTapCancel: () =>
                              controller.hoverPartner.value = false,
                          child: AnimatedScale(
                            scale: effectiveScale,
                            duration: animDuration,
                            curve: animCurve,
                            child: Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(top: 36),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.bgColor
                                      : AppColors.mainColor.applyOpacity(0.9),
                                  width: 2,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: SizedBox(
                                  height: 160,
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Image.asset(
                                        'assets/images/partner_place.webp',
                                        fit: BoxFit.cover,
                                      ),
                                      Container(
                                        color: Colors.black.applyOpacity(
                                            isSelected ? 0.45 : 0.35),
                                      ),
                                      Center(
                                        child: AnimatedDefaultTextStyle(
                                          duration: animDuration,
                                          curve: animCurve,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: titleSize,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                color: AppColors.mainColor
                                                    .applyOpacity(0.8),
                                                borderRadius:
                                                    BorderRadius.circular(16)),
                                            child: Text('partner'.tr),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                    const Spacer(),
                    Obx(
                      () => Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 52),
                            backgroundColor: controller.isEnabled
                                ? AppColors.kDarkBlue
                                : AppColors.mainColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: controller.isEnabled
                              ? null
                              : () {
                                  if (controller.selectedRole.value ==
                                      'Partner') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const PartnerOnBoarding()),
                                    );
                                  } else {
                                    Get.offNamed(Routes.REGISTER_STEPPER);
                                  }
                                },
                          child: Text(
                            'next'.tr,
                            style: const TextStyle(
                                fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
