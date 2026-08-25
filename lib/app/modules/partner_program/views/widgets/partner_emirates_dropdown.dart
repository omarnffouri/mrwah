import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mrwah/app/core/resources/app_colors.dart';
import 'package:mrwah/app/modules/partner_program/controllers/partner_program_controller.dart';

class PartnerEmiratesDropdown extends GetView<PartnerProgramController> {
  const PartnerEmiratesDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.mainColor, width: 2),
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: controller.selectedEmirate.value.isEmpty
                  ? null
                  : controller.selectedEmirate.value,
              isExpanded: true,
              hint: Text(
                "select_emirate".tr,
                style: TextStyle(color: Colors.grey.shade600),
              ),
              items: controller.emiratesApi.map((engCity) {
                return DropdownMenuItem<String>(
                  value: engCity, // <-- STORED IN ENGLISH
                  child: Text(
                    controller
                        .emiratesUi[engCity]!, // <-- DISPLAY ARABIC/ENGLISH
                    style: const TextStyle(
                      color: Color(0xFF0B1437),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                controller.selectedEmirate.value = value ?? "";
              },
            ),
          ),
        ));
  }
}
