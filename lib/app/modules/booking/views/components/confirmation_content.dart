import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mrwah/app/core/resources/app_colors.dart';
import 'package:mrwah/app/modules/booking/views/controllers/booking_controller.dart';

class ConfirmationContent extends GetView<BookingController> {
  const ConfirmationContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  controller.carImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stacktrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: Icon(Icons.car_rental,
                          color: Colors.grey[400], size: 40),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              Text(
                controller.carName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                controller.carModel,
                style: const TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 6),
            ],
          ),
          const SizedBox(height: 18),

          // Booking Information
          Text(
            "Booking Information",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.bgColor,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          _infoRow("name".tr,
              "${controller.user.value.firstname} ${controller.user.value.lastname}"),
          Obx(
            () => _infoRow(
              "pick_up_date".tr,
              controller.pickupDate.value,
            ),
          ),
          Obx(
            () => _infoRow(
              "return_date".tr,
              controller.returnDate.value,
            ),
          ),

          Obx(
            () => Visibility(
                visible: controller.deliverToMe.value,
                child: _infoRow("location".tr, "Al nahda street")),
          ),
          const SizedBox(height: 16),

          Text(
            "payment".tr,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.bgColor,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          _infoRow("amount".tr, "AED ${controller.carPrice}"),
          _infoRow("service_fee".tr, "AED ${15}"),
          const Divider(height: 24, thickness: 1),
          _infoRow(
            "total_amount".tr,
            "AED ${controller.total}",
            valueStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 26),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, {TextStyle? valueStyle}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(
            "• $label",
            style: TextStyle(color: AppColors.mainColor),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: valueStyle ??
                  const TextStyle(
                    color: AppColors.kDarkBlue,
                    fontWeight: FontWeight.w500,
                  ),
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }
}
