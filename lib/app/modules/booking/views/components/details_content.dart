import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mrwah/app/core/helpers/extensions.dart';
import 'package:mrwah/app/core/helpers/validators.dart';
import 'package:mrwah/app/core/resources/app_colors.dart';
import 'package:mrwah/app/core/widgets/app_textfield.dart';
import 'package:mrwah/app/modules/booking/views/controllers/booking_controller.dart';

class DetailsContent extends GetView<BookingController> {
  const DetailsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => SwitchListTile(
                  activeTrackColor: AppColors.mainColor,
                  inactiveTrackColor: AppColors.bgColor,
                  thumbColor: WidgetStateProperty.all(Colors.white),
                  value: controller.deliverToMe.value,
                  onChanged: (val) => controller.deliverToMe.value = val,
                  title: Text(
                    controller.deliverToMe.value
                        ? "deliver_car_to_me".tr
                        : "book_car_in_office".tr,
                    style: TextStyle(color: AppColors.bgColor),
                  ),
                  subtitle: Text(
                    "switch_booking_mode".tr,
                    style:
                        TextStyle(color: AppColors.bgColor.applyOpacity(0.5)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: controller.fullName,
                icon: Icons.person_outline,
                label: "full_name".tr,
                readOnly: true,
              ),
              const SizedBox(height: 12),
              AppTextField(
                icon: Icons.email_outlined,
                controller: controller.email,
                label: "email_address".tr,
                readOnly: true,
              ),
              const SizedBox(height: 12),
              AppTextField(
                icon: Icons.phone_outlined,
                controller: controller.phoneNumber,
                label: "contact_number".tr,
              ),
              Obx(() {
                if (controller.deliverToMe.value) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      AppTextField(
                        label: "your_location".tr,
                        icon: Icons.location_searching_outlined,
                        controller: controller.userLocation,
                        validator: InputValidators.required,
                        onTap: () => controller.openLocationPickerBottomSheet(),
                        readOnly: true,
                      ),
                    ],
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }),
              const SizedBox(height: 12),
              Text('upload_emirates_id'.tr,
                  style: const TextStyle(
                      color: AppColors.kDarkBlue, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              uploadTile('upload_id_front'.tr, controller.idFront, 'front',
                  controller),
              const SizedBox(height: 12),
              uploadTile(
                  'upload_id_back'.tr, controller.idBack, 'back', controller),
              const SizedBox(height: 12),
              Text('upload_driving_license'.tr,
                  style: const TextStyle(
                      color: AppColors.kDarkBlue, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              uploadTile('driving_license_hint'.tr, controller.license,
                  'license', controller),
              const SizedBox(height: 20),
              Text("rental_date_time".tr,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.bgColor,
                  )),
              const SizedBox(height: 8),
              Obx(() => Row(
                    children: [
                      ChoiceChip(
                        label: Text(
                          "day".tr,
                          style: const TextStyle(color: Colors.white),
                        ),
                        selectedColor: AppColors.mainColor,
                        backgroundColor: AppColors.bgColor,
                        selected: controller.rentalType.value == "Day",
                        onSelected: (_) => controller.updateRentalType("Day"),
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: Text(
                          "weekly".tr,
                          style: const TextStyle(color: Colors.white),
                        ),
                        selectedColor: AppColors.mainColor,
                        backgroundColor: AppColors.bgColor,
                        selected: controller.rentalType.value == "Weekly",
                        onSelected: (_) =>
                            controller.updateRentalType("Weekly"),
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: Text(
                          "monthly".tr,
                          style: const TextStyle(color: Colors.white),
                        ),
                        selectedColor: AppColors.mainColor,
                        backgroundColor: AppColors.bgColor,
                        selected: controller.rentalType.value == "Monthly",
                        onSelected: (_) =>
                            controller.updateRentalType("Monthly"),
                      ),
                    ],
                  )),
              const SizedBox(height: 16),
              Row(
                children: [
                  Obx(
                    () => Expanded(
                        child: AppTextField(
                      label: "Pick up Date",
                      readOnly: true,
                      onTap: () => controller.pickDate(context, isPickup: true),
                      icon: Icons.calendar_today_outlined,
                      controller: TextEditingController(
                        text: controller.pickupDate.value,
                      ),
                    )),
                  ),
                  const SizedBox(width: 12),
                  Obx(() => Expanded(
                          child: AppTextField(
                        label: "Return Date",
                        readOnly: true,
                        onTap: () =>
                            controller.pickDate(context, isPickup: false),
                        icon: Icons.calendar_today_outlined,
                        controller: TextEditingController(
                          text: controller.returnDate.value,
                        ),
                      ))),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

Widget uploadTile(String label, Rx<File?> fileObs, String target,
    BookingController controller) {
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
