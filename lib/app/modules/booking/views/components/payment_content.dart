import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mrwah/app/core/resources/app_colors.dart';
import 'package:mrwah/app/core/widgets/app_textfield.dart';
import 'package:mrwah/app/modules/booking/views/controllers/booking_controller.dart';

class PaymentContent extends GetView<BookingController> {
  const PaymentContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'assets/images/payment_card.png',
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 20),
          Text(
            "Select payment method",
            style: TextStyle(
              color: AppColors.bgColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Obx(() => Row(
                children: [
                  ChoiceChip(
                    label: const Text(
                      "Cash Payment",
                      style: TextStyle(color: Colors.white),
                    ),
                    selectedColor: AppColors.mainColor,
                    backgroundColor: AppColors.bgColor,
                    selected: controller.paymentType.value == "Cash Payment",
                    onSelected: (_) =>
                        controller.paymentType.value = "Cash Payment",
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text(
                      "Card Payment",
                      style: TextStyle(color: Colors.white),
                    ),
                    selectedColor: AppColors.mainColor,
                    backgroundColor: AppColors.bgColor,
                    selected: controller.paymentType.value == "Card Payment",
                    onSelected: (_) =>
                        controller.paymentType.value = "Card Payment",
                  ),
                  const SizedBox(width: 8),
                ],
              )),
          const SizedBox(height: 20),

          Text(
            "Card Information",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.bgColor,
            ),
          ),
          const SizedBox(height: 12),

          const AppTextField(icon: Icons.person_outline, label: "Full Name"),
          const SizedBox(height: 12),
          const AppTextField(
              icon: Icons.email_outlined, label: "Email Address"),
          const SizedBox(height: 12),
          const AppTextField(icon: Icons.credit_card, label: "Number"),
          const SizedBox(height: 12),
          const Row(
            children: [
              Expanded(
                  child: AppTextField(
                      icon: Icons.calendar_today, label: "MM / YY")),
              SizedBox(width: 12),
              Expanded(
                  child: AppTextField(icon: Icons.lock_outline, label: "CVC")),
            ],
          ),
          const SizedBox(height: 20),

          /// Country or region
          Text(
            "Country or region",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.bgColor,
            ),
          ),
          const SizedBox(height: 12),
          const AppTextField(
              icon: Icons.location_on_outlined, label: "United States"),
          const SizedBox(height: 12),
          const AppTextField(
              icon: Icons.local_post_office_outlined, label: "ZIP"),
          const SizedBox(height: 20),

          // ElevatedButton.icon(
          //   onPressed: () {},
          //   icon: const Icon(Icons.apple, color: Colors.black),
          //   label: const Text("Apple Pay"),
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor: Colors.white,
          //     foregroundColor: Colors.black,
          //     minimumSize: const Size(double.infinity, 50),
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(12),
          //       side: const BorderSide(color: Colors.black12),
          //     ),
          //   ),
          // ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
