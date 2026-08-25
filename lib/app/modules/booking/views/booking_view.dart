import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:mrwah/app/core/resources/app_colors.dart';
import 'package:mrwah/app/core/widgets/background_widget.dart';
import 'package:mrwah/app/modules/booking/views/components/confirmation_content.dart';
import 'package:mrwah/app/modules/booking/views/widgets/booking_button.dart';
import 'controllers/booking_controller.dart';
import 'components/details_content.dart';

class BookingView extends GetView<BookingController> {
  const BookingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: SafeArea(
        child: SizedBox(
          height: 90,
          child: BookingButton(
            controller: controller,
            amount: controller.total.toInt(),
          ),
        ),
      ),
      body: Stack(
        children: [
          const BackgroundWidget(),
          Obx(() {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 70, right: 16),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (controller.currentStep.value > 0) {
                            controller.currentStep.value--;
                          } else {
                            Navigator.pop(context);
                          }
                        },
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: AppColors.bgColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(
                        'booking_details'.tr,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.bgColor,
                            fontSize: 22),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                EasyStepper(
                  activeStep: controller.currentStep.value,
                  stepShape: StepShape.circle,
                  activeStepBorderColor: AppColors.mainColor,
                  stepBorderRadius: 15,
                  borderThickness: 2,
                  stepRadius: 18,
                  showLoadingAnimation: false,
                  finishedStepBackgroundColor: AppColors.bgColor,
                  unreachedStepBackgroundColor: Colors.white,
                  unreachedStepBorderColor: AppColors.bgColor,
                  activeStepTextColor: AppColors.bgColor,
                  finishedStepTextColor: AppColors.bgColor,
                  unreachedStepTextColor: AppColors.mainColor,
                  lineStyle: LineStyle(
                    lineLength: 100,
                    lineType: LineType.dotted,
                    defaultLineColor: AppColors.bgColor,
                  ),
                  steps: [
                    EasyStep(
                      customStep: CircleAvatar(
                        radius: 14,
                        backgroundColor: AppColors.bgColor,
                        child: const Text(
                          "1",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                      title: 'booking_steps_details'.tr,
                    ),
                    EasyStep(
                      customStep: CircleAvatar(
                        radius: 14,
                        backgroundColor: AppColors.bgColor,
                        child: const Text(
                          "2",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                      title: 'confirmation'.tr,
                    ),
                  ],
                ),
                Expanded(
                  child: IndexedStack(
                    index: controller.currentStep.value,
                    children: const [
                      DetailsContent(),
                      ConfirmationContent(),
                    ],
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
