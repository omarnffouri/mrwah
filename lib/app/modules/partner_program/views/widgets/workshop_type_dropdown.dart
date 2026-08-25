import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mrwah/app/core/enums/service_type_enum.dart';
import 'package:mrwah/app/core/resources/app_colors.dart';
import 'package:mrwah/app/modules/partner_program/controllers/partner_program_controller.dart';

class WorkshopTypeDropdown extends GetView<PartnerProgramController> {
  const WorkshopTypeDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.mainColor, width: 2),
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: Obx(() => DropdownButton<ServiceType>(
            value: controller.serviceType.value,
            isExpanded: true,
            underline: const SizedBox(),
            hint: Text(
              "select_service_type".tr,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            items: ServiceType.values
                .map((type) => DropdownMenuItem<ServiceType>(
                      value: type,
                      child: Text(
                        type.trKey.tr,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ))
                .toList(),
            onChanged: (val) =>
                controller.serviceType.value = val ?? ServiceType.carWash,
          )),
    );
  }
}
