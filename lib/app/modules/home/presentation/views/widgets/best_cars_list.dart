import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:mrwah/app/core/helpers/extensions.dart';
import 'package:mrwah/app/core/resources/app_colors.dart';
import 'package:mrwah/app/modules/home/domain/entities/car_entity.dart';
import 'package:mrwah/app/modules/home/presentation/controllers/home_controller.dart';
import 'package:mrwah/app/routes/app_pages.dart';

class BestCarsListWidget extends StatelessWidget {
  final HomeController controller;

  const BestCarsListWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: SpinKitSpinningLines(
            color: AppColors.bgColor,
            size: 28,
          ),
        );
      }

      if (controller.isError.value) {
        return Center(child: Text(controller.errorMessage.value));
      }

      final cars = controller.filteredCars;
      if (cars.isEmpty) {
        return const Center(child: Text('No cars available'));
      }
      final isRTL = Directionality.of(context) == TextDirection.rtl;

      return SizedBox(
        height: 250,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          itemCount: cars.length,
          itemBuilder: (context, index) {
            final CarEntity car = cars[index];
            final carImages = car.images.isNotEmpty
                ? car.images
                : ['https://via.placeholder.com/150'];

            return GestureDetector(
              onTap: () => Get.toNamed(
                Routes.CAR_DETAIL,
                arguments: car,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Container(
                    width: 220,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.mainColor),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 130,
                          child: Stack(
                            children: [
                              // Car Image (navigates to detail)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: PageView.builder(
                                  physics:
                                      const BouncingScrollPhysics(), // disable swiping
                                  itemCount: carImages.length,
                                  itemBuilder: (context, index) {
                                    return Image.network(
                                      carImages[index],
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      errorBuilder:
                                          (context, error, stacktrace) {
                                        return Container(
                                          color: Colors.grey[200],
                                          child: Icon(
                                            Icons.car_rental,
                                            color: Colors.grey[400],
                                            size: 40,
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),

                              // ❤️ Favorite button (overlay)
                              Positioned(
                                right: 8,
                                top: 8,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    controller
                                        .toggleFavorite(car.id.toString());
                                  },
                                  child: Obx(() {
                                    final isFav = controller.favorites
                                        .contains(car.id.toString());
                                    return Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.black.applyOpacity(0.3),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        isFav
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color:
                                            isFav ? Colors.red : Colors.white,
                                        size: 22,
                                      ),
                                    );
                                  }),
                                ),
                              ),

                              // Optional arrows if multiple images
                              if (carImages.length > 1)
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  bottom: 0,
                                  child: Icon(
                                    isRTL
                                        ? Icons.chevron_right
                                        : Icons.chevron_left,
                                    color: Colors.white,
                                    size: 26,
                                  ),
                                ),
                              if (carImages.length > 1)
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  bottom: 0,
                                  child: Icon(
                                    isRTL
                                        ? Icons.chevron_left
                                        : Icons.chevron_right,
                                    color: Colors.white,
                                    size: 26,
                                  ),
                                ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 6),

                        // ================= CAR INFO =================
                        Text(
                          car.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.textColor,
                          ),
                        ),
                        const Row(
                          children: [
                            Icon(Icons.star, color: Colors.orange, size: 16),
                            SizedBox(width: 4),
                            Text(
                              '5.0',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: AppColors.textColor,
                              size: 15,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              car.owner?.state ?? 'N/A',
                              style: TextStyle(
                                color: AppColors.textColor,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.event_seat,
                              size: 15,
                              color: AppColors.textColor,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              "${car.seats ?? 4} Seats",
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textColor,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              "${car.price.toInt()} AED",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: AppColors.bgColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
