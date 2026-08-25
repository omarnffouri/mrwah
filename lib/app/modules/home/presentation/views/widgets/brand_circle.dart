import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mrwah/app/core/helpers/extensions.dart';
import 'package:mrwah/app/core/resources/app_colors.dart';
import 'package:mrwah/app/modules/home/presentation/controllers/home_controller.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class BrandCircle extends StatelessWidget {
  final HomeController controller;

  const BrandCircle({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.brands.isEmpty) {
        return const Center(
          child: SpinKitSpinningLines(
            color: Colors.white,
            size: 28,
          ),
        );
      }

      final brands = controller.brands;
      if (brands.isEmpty) {
        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: SizedBox(
            height: 60,
            child: Center(child: Text('No brands available')),
          ),
        );
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            spacing: 14,
            children: brands.map((brand) {
              final bool isSelected =
                  controller.selectedBrand.value == brand.name;

              return Padding(
                padding: const EdgeInsets.only(top: 12),
                child: GestureDetector(
                  onTap: () => controller.selectBrand(brand.name),
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOut,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.kGold
                                : Colors.transparent,
                            width: 2,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: AppColors.kGold.applyOpacity(0.5),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : [],
                        ),
                        child: CircleAvatar(
                          backgroundColor: isSelected
                              ? AppColors.kGold
                              : AppColors.mainColor,
                          radius: isSelected ? 24 : 21,
                          child: brand.logo.isNotEmpty
                              ? ClipOval(
                                  child: Image.network(
                                    brand.logo,
                                    width: 32,
                                    height: 32,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Icon(
                                  Icons.image_not_supported,
                                  color: Colors.white,
                                ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        brand.name,
                        style: TextStyle(
                          color: isSelected
                              ? AppColors.kGold
                              : AppColors.mainColor,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );
    });
  }
}
