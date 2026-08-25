import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mrwah/app/core/resources/app_colors.dart';
import 'package:mrwah/app/modules/home/presentation/controllers/home_controller.dart';
import 'package:mrwah/app/routes/app_pages.dart';

class FavoriteCarsView extends StatelessWidget {
  final HomeController controller = Get.find<HomeController>();

  FavoriteCarsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1B45),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.mainColor),
        title: Text(
          "fav_cars".tr,
          style: TextStyle(
            color: AppColors.mainColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: const BoxDecoration(
          color: Color(0xFFF8F8F8),
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Obx(() {
          final favoriteCars = controller.bestCars
              .where((car) => controller.favorites.contains(car.id.toString()))
              .toList();

          if (favoriteCars.isEmpty) {
            return Center(
              child: Text(
                "no_favorite_cars".tr,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF0E1B45),
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }

          return ListView.separated(
            itemCount: favoriteCars.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final car = favoriteCars[index];
              return InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => Get.toNamed(Routes.CAR_DETAIL, arguments: car),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Car image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          car.images.isNotEmpty
                              ? car.images.first
                              : 'https://via.placeholder.com/80',
                          width: 80,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Car info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              car.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0E1B45),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "\$${car.price.toInt()}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Remove from favorites
                      IconButton(
                        icon: const Icon(Icons.favorite, color: Colors.red),
                        onPressed: () {
                          controller.toggleFavorite(car.id.toString());
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
