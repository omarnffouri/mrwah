import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:mrwah/app/core/resources/app_colors.dart';
import 'package:mrwah/app/modules/booking/views/controllers/booking_controller.dart';

class BookingButton extends StatelessWidget {
  const BookingButton({super.key, required this.controller, this.amount});

  final BookingController controller;
  final int? amount;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.bgColor,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: controller.isLoading.value
              ? null
              : () {
                  if (controller.currentStep.value <
                      controller.totalSteps - 1) {
                    controller.nextStep();
                  } else {
                    controller.submitBooking(context);
                  }
                },
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, anim) => FadeTransition(
              opacity: anim,
              child: child,
            ),
            child: controller.isLoading.value
                ? const SpinKitSpinningLines(
                    color: Colors.white,
                    size: 28,
                    key: ValueKey('spinner'),
                  )
                : Text(
                    controller.currentStep.value == controller.totalSteps - 1
                        ? "Pay $amount AED"
                        : "Next",
                    key: const ValueKey('text'),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
