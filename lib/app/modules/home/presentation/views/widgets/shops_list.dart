import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:mrwah/app/core/resources/app_colors.dart';
import 'package:mrwah/app/modules/home/presentation/controllers/home_controller.dart';
import 'package:mrwah/app/routes/app_pages.dart';

class ShopsList extends GetView<HomeController> {
  const ShopsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
            child: SpinKitSpinningLines(
          color: AppColors.bgColor,
          size: 28,
        ));
      }

      if (controller.isError.value) {
        return Center(child: Text(controller.errorMessage.value));
      }

      final cars = controller.bestCars;
      if (cars.isEmpty) {
        return const Center(child: Text('No cars available'));
      }

      return SizedBox(
        height: 150,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          itemCount: cars.length,
          itemBuilder: (context, index) {
            final car = cars[index];
            final carImages = car.images.isNotEmpty
                ? car.images
                : ['https://via.placeholder.com/150'];

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: GestureDetector(
                onTap: () => Get.toNamed(
                  Routes.CAR_DETAIL,
                  arguments: car,
                ),
                child: Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Container(
                    width: 350,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.mainColor),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        // Left: Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            carImages.first,
                            width: 110,
                            height: 90,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stacktrace) =>
                                Container(
                              width: 110,
                              height: 90,
                              color: Colors.grey[200],
                              child: Icon(Icons.car_rental,
                                  color: Colors.grey[400], size: 38),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        // Right: Text info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
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
                                  Icon(Icons.star,
                                      color: Colors.orange, size: 14),
                                  SizedBox(width: 4),
                                  Text(
                                    '5.0',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(Icons.location_on,
                                      color: AppColors.textColor, size: 13),
                                  const SizedBox(width: 3),
                                  Flexible(
                                    child: Text(
                                      car.location ?? 'N/A',
                                      style: TextStyle(
                                        color: AppColors.textColor,
                                        fontSize: 12,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(Icons.event_seat,
                                      size: 13, color: AppColors.textColor),
                                  const SizedBox(width: 3),
                                  Text(
                                    "${car.seats ?? 4} Seats",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textColor,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    "\$${car.price.toInt()}/Day",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: AppColors.bgColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
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
