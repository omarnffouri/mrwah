import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mrwah/app/core/resources/app_colors.dart';
import 'package:mrwah/app/core/widgets/app_button.dart';
import 'package:mrwah/app/modules/shop_detail/views/controllers/shop_detail_controller.dart';

class BookServiceBottomSheet extends StatelessWidget {
  final ShopDetailController controller;
  const BookServiceBottomSheet({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text("Choose date & payment",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.kDarkBlue)),
          const SizedBox(height: 12),
          Obx(() {
            return ListTile(
              title: Text(controller.selectedDateStr.value.isEmpty
                  ? "Select date & time"
                  : controller.selectedDateStr.value),
              leading: const Icon(Icons.calendar_month),
              trailing: const Icon(Icons.edit),
              onTap: () => controller.pickDateTime(context),
            );
          }),
          const SizedBox(height: 16),
          Obx(() => AppButton(
                onPressed: controller.isLoading.value
                    ? null
                    : controller.submitBooking,
                text: 'Proceed to Payment',
              )),
          const SizedBox(height: 8),
        ]),
      ),
    );
  }
}
