import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mrwah/app/core/resources/app_colors.dart';
import 'package:mrwah/app/modules/car_detail/controllers/car_detail_controller.dart';
import 'package:mrwah/app/modules/home/domain/entities/car_entity.dart';

class ImageSlider extends GetView<CarDetailController> {
  final CarEntity car;
  const ImageSlider({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: 280,
          child: PageView.builder(
            controller: controller.pageController,
            itemCount: car.images.length,
            onPageChanged: (index) {
              controller.currentPage.value = index;
            },
            itemBuilder: (context, index) {
              return Image.network(
                car.images[index],
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stacktrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: Icon(Icons.car_rental,
                        color: Colors.grey[400], size: 40),
                  );
                },
              );
            },
          ),
        ),
        Positioned(
          bottom: 32,
          left: 0,
          right: 0,
          child: Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  car.images.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: controller.currentPage.value == index ? 10 : 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: controller.currentPage.value == index
                          ? AppColors.bgColor
                          : AppColors.mainColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              )),
        ),
        Positioned(
          left: 16,
          top: 0,
          bottom: 130,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Center(
              child: Icon(Icons.arrow_back_ios,
                  textDirection: TextDirection.ltr,
                  color: AppColors.kDarkBlue,
                  size: 28),
            ),
          ),
        ),
      ],
    );
  }
}
