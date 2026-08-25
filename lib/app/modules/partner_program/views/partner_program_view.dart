import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mrwah/app/core/helpers/extensions.dart';
import 'package:mrwah/app/core/helpers/uae_formatter.dart';
import 'package:mrwah/app/core/helpers/validators.dart';
import 'package:mrwah/app/core/resources/app_colors.dart';
import 'package:mrwah/app/core/widgets/app_button.dart';
import 'package:mrwah/app/core/widgets/app_textfield.dart';
import 'package:mrwah/app/core/widgets/custom_textfield.dart';
import 'package:mrwah/app/modules/partner_program/views/widgets/partner_emirates_dropdown.dart';
import 'package:mrwah/app/modules/partner_program/views/widgets/workshop_type_dropdown.dart';
import 'package:mrwah/app/routes/app_pages.dart';
import '../controllers/partner_program_controller.dart';

class PartnerProgramView extends GetView<PartnerProgramController> {
  const PartnerProgramView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: controller.formKey,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            image: const DecorationImage(
              image: AssetImage('assets/images/main_bg.png'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 18,
                offset: Offset(0, 6),
              )
            ],
          ),
          child: SlideTransition(
            position: controller.slideAnim,
            child: SingleChildScrollView(
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 32,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => Get.offAllNamed(Routes.LOGIN),
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: AppColors.mainColor,
                              size: 32,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 6, left: 4),
                            child: Image.asset(
                              'assets/images/mrwh_logo.png',
                              width: 45,
                              height: 45,
                              color: AppColors.mainColor,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 22),

                      // Title
                      Text(
                        "workshop_registration".tr,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.kDarkBlue,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "register_workshop_below".tr,
                        style: const TextStyle(
                            fontSize: 16, color: AppColors.kDarkBlue),
                      ),
                      const SizedBox(height: 28),

                      _label("workshop_name".tr),
                      AppTextField(
                        controller: controller.workshopName,
                        hintText: "your_workshop_name".tr,
                        icon: Icons.store,
                        filled: true,
                        validator: InputValidators.required,
                      ),
                      const SizedBox(height: 16),

                      _label("owner_first_name".tr),
                      AppTextField(
                        controller: controller.ownerFirstName,
                        hintText: "owner_first_name".tr,
                        icon: Icons.person,
                        filled: true,
                        validator: InputValidators.required,
                      ),
                      const SizedBox(height: 16),
                      _label("owner_last_name".tr),
                      AppTextField(
                        controller: controller.ownerLastName,
                        hintText: "owner_last_name".tr,
                        icon: Icons.person,
                        filled: true,
                        validator: InputValidators.required,
                      ),
                      const SizedBox(height: 16),
                      _label("contact_number".tr),
                      CustomTextField(
                        hintText: "Phone number",
                        controller: controller.contact,
                        keyboardType: TextInputType.phone,
                        prefixIcon: null,
                        validator: uaePhoneValidator,
                        filled: true,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          UaePhoneInputFormatter(),
                        ],
                        prefixWidget: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 12),
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
                      const SizedBox(height: 16),
                      // EMAIL
                      _label("email".tr),

                      AppTextField(
                        controller: controller.email,
                        hintText: "email_address".tr,
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        filled: true,
                        validator: InputValidators.email,
                      ),
                      const SizedBox(height: 16),

                      _label("workshop_address".tr),
                      AppTextField(
                        hintText: "workshop_address".tr,
                        icon: Icons.location_searching_outlined,
                        controller: controller.userLocation,
                        validator: InputValidators.required,
                        onTap: () => controller.openLocationPickerBottomSheet(),
                        filled: true,
                        readOnly: true,
                      ),
                      const SizedBox(height: 16),
                      _label("emirate".tr),
                      const PartnerEmiratesDropdown(),
                      const SizedBox(height: 16),

                      _label("Type of Workshop"),
                      const WorkshopTypeDropdown(),

                      const SizedBox(height: 16),

                      _label("upload_business_license".tr),
                      uploadTile('business_license_hint'.tr,
                          controller.licenseFile, 'license', controller),
                      const SizedBox(height: 16),

                      _label("upload_id_front".tr),
                      uploadTile('id_front_hint'.tr, controller.idFront,
                          'front', controller),
                      const SizedBox(height: 22),
                      _label("upload_id_back".tr),
                      uploadTile('id_back_hint'.tr, controller.idBack, 'back',
                          controller),

                      // // TERMS
                      // Row(
                      //   children: [
                      //     Checkbox(
                      //       value: controller.agreeTerms.value,
                      //       onChanged: (v) =>
                      //           controller.agreeTerms.value = v ?? false,
                      //       activeColor: AppColors.mainColor,
                      //       shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(6)),
                      //     ),
                      //     Expanded(
                      //       child: Text(
                      //         "I agree to the terms and conditions.",
                      //         style: TextStyle(
                      //           color: AppColors.kDarkBlue.withOpacity(0.88),
                      //           fontSize: 15,
                      //           fontWeight: FontWeight.w500,
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      const SizedBox(height: 18),
                      Obx(
                        () => AppButton(
                          text: 'submit'.tr,
                          isLoading: controller.isLoading.value,
                          onPressed: controller.submit,
                          backgroundColor: AppColors.mainColor,
                        ),
                      )
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 3),
        child: Text(text,
            style: TextStyle(
                color: AppColors.kDarkBlue.applyOpacity(0.80),
                fontWeight: FontWeight.w600,
                fontSize: 15)),
      );
}

Widget uploadTile(String label, Rx<File?> fileObs, String target,
    PartnerProgramController controller) {
  return GestureDetector(
    onTap: () => controller.pickImage(fileObs, target),
    child: Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.mainColor, width: 1.2),
      ),
      child: Obx(() {
        final file = fileObs.value;
        return file == null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.upload_file, color: AppColors.bgColor),
                  const SizedBox(width: 8),
                  Text(label, style: TextStyle(color: AppColors.bgColor)),
                ],
              )
            : Row(
                children: [
                  const SizedBox(width: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(file,
                        width: 90, height: 90, fit: BoxFit.cover),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(label,
                        style: TextStyle(color: AppColors.mainColor)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_forever,
                        color: Colors.redAccent),
                    onPressed: () => fileObs.value = null,
                  ),
                ],
              );
      }),
    ),
  );
}
