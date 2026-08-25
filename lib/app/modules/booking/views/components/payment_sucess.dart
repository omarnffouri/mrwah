import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:mrwah/app/core/resources/app_colors.dart';
import 'package:mrwah/app/routes/app_pages.dart';

class PaymentSuccessContent extends StatelessWidget {
  final String? carName;
  final String? rentalDate;
  final String? amount;
  final String? total;

  const PaymentSuccessContent({
    super.key,
    this.carName,
    this.rentalDate,
    this.amount,
    this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.kDarkBlue,
                    ),
                    onPressed: () => Get.back(),
                  ),
                  const Text(
                    "",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppColors.kDarkBlue,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.more_horiz_rounded,
                      color: AppColors.kDarkBlue,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Lottie.asset(
                'assets/images/payment_sucess.json',
              ),
              const SizedBox(height: 2),

              // Payment successful text
              Text(
                "payment_successful".tr,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColors.kDarkBlue,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "payment_success_message".tr,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 22),

              // Booking info box
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "booking_information_title".tr,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.kDarkBlue,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _infoRow("name_label".tr, carName ?? "—"),
                    _infoRow("rental_date".tr, rentalDate ?? "—"),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              // Transaction detail
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "transaction_detail".tr,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.kDarkBlue,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _infoRow("transaction_date".tr, DateTime.now().toIso8601String()),
              const Row(
                children: [
                  // Text(
                  //   "Payment  Method",
                  //   style: TextStyle(
                  //     color: Colors.black87,
                  //     fontSize: 14,
                  //   ),
                  // ),
                  // Spacer(),
                  // Text(
                  //   "VISA", // use your asset or network img
                  // ),
                  // SizedBox(width: 6),
                  // Text(
                  //   paymentMethod,
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.w500,
                  //     fontSize: 14,
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(height: 6),
              _infoRow("amount".tr, amount ?? "—"),
              _infoRow("service_fee_label".tr, "15 AED"),

              const Divider(thickness: 1, height: 22),
              _infoRow(
                "total_amount_label".tr,
                total ?? "—",
                valueStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),

              // // Action buttons
              // Row(
              //   children: [
              //     Expanded(
              //       child: OutlinedButton.icon(
              //         onPressed: () {
              //           // controller.downloadReceipt();
              //         },
              //         icon: const Icon(
              //           Icons.download,
              //           size: 18,
              //           color: AppColors.kDarkBlue,
              //         ),
              //         label: const Text("Download Receipt"),
              //         style: OutlinedButton.styleFrom(
              //           foregroundColor: Colors.grey.shade700,
              //           side: BorderSide(color: Colors.grey.shade300),
              //           backgroundColor: Colors.grey.shade100,
              //           padding: const EdgeInsets.symmetric(vertical: 12),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              // const SizedBox(height: 8),
              // Row(
              //   children: [
              //     Expanded(
              //       child: OutlinedButton.icon(
              //         onPressed: () {
              //           // controller.shareReceipt();
              //         },
              //         icon: const Icon(
              //           Icons.share,
              //           size: 18,
              //           color: AppColors.kDarkBlue,
              //         ),
              //         label: const Text(
              //             "Shar Your Receipt"), // typo is in your screenshot, keep/fix as you want!
              //         style: OutlinedButton.styleFrom(
              //           foregroundColor: Colors.grey.shade700,
              //           side: BorderSide(color: Colors.grey.shade300),
              //           backgroundColor: Colors.white,
              //           padding: const EdgeInsets.symmetric(vertical: 12),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              const SizedBox(height: 22),

              // Back to Home
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.offAllNamed(Routes.MAIN_SCREEN);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.kDarkBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  child: Text(
                    "back_to_home".tr,
                    style: const TextStyle(
                      color: AppColors.kGold,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, {TextStyle? valueStyle}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, top: 2),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: valueStyle ??
                const TextStyle(
                  color: AppColors.kDarkBlue,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
          ),
        ],
      ),
    );
  }
}
