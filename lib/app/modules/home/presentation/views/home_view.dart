import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mrwah/app/core/helpers/extensions.dart';
import 'package:mrwah/app/core/resources/app_colors.dart';
import 'package:mrwah/app/core/widgets/app_gradient.dart';
import 'package:mrwah/app/core/widgets/custom_textfield.dart';
import 'package:mrwah/app/core/widgets/user_profile_image.dart';
import 'package:mrwah/app/modules/all_vehicles/controllers/all_vehicles_controller.dart';
import 'package:mrwah/app/modules/home/presentation/controllers/home_controller.dart';
import 'package:mrwah/app/modules/home/presentation/views/widgets/brand_circle.dart';
import 'package:mrwah/app/modules/home/presentation/views/widgets/best_cars_list.dart';
import 'package:mrwah/app/modules/home/presentation/views/widgets/car_filter_sheet.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mrwah/app/routes/app_pages.dart';
import 'package:mrwah/app/services/storage_service.dart';

class HomeView extends GetView<HomeController> {
  final double brandIconSize = 50.0;
  final double sheetTop = 360;

  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const AppGradient(),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // AppBar
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Row(
                    children: [
                      UserProfileImage(
                        image: controller.user.value.profileImage ?? '',
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 2),
                          Text(
                            'hello'.tr,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.mainColor,
                            ),
                          ),
                          Text(
                            controller.user.value.firstname ?? '',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.mainColor,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      // Stack(
                      //   children: [
                      //     IconButton(
                      //       icon: Icon(
                      //         Icons.notifications_none_outlined,
                      //         color: AppColors.mainColor,
                      //         size: 30,
                      //       ),
                      //       onPressed: () {},
                      //     ),
                      //     Positioned(
                      //       right: 8,
                      //       top: 8,
                      //       child: Container(
                      //         padding: const EdgeInsets.all(3),
                      //         decoration: BoxDecoration(
                      //           color: AppColors.mainColor,
                      //           shape: BoxShape.circle,
                      //         ),
                      //         child: const Text(
                      //           '2',
                      //           style: TextStyle(
                      //             color: Colors.white,
                      //             fontSize: 11,
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Search & Filter
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          hintText: 'search_car_hint'.tr,
                          hintColor: AppColors.kGold.applyOpacity(0.5),
                          prefixIcon: Icons.search,
                          textColor: Colors.white,
                          borderColor: AppColors.mainColor,
                          onChanged: (value) =>
                              controller.searchQuery.value = value,
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () {
                          Get.put(AllVehiclesController());
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => const CarFiltersSheet(),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.mainColor),
                          ),
                          padding: const EdgeInsets.all(14),
                          child: Icon(
                            Icons.tune,
                            size: 24,
                            color: AppColors.mainColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Brands section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Align(
                    alignment: StorageService.isArabic
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Text(
                      'brands'.tr,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: AppColors.mainColor,
                      ),
                    ),
                  ),
                ),
                BrandCircle(controller: controller),
              ],
            ),
          ),
          Positioned(
            top: sheetTop,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  image: AssetImage('assets/images/main_bg.png'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Obx(() {
                if (controller.isLoading.value && controller.bestCars.isEmpty) {
                  return Center(
                    child: SpinKitSpinningLines(
                      color: AppColors.bgColor,
                      size: 28,
                    ),
                  );
                }

                return RefreshIndicator(
                  color: AppColors.mainColor,
                  backgroundColor: Colors.white,
                  onRefresh: () async {
                    await controller.fetchHomeData();
                  },
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                        child: Row(
                          children: [
                            Text(
                              'best_vehicles'.tr,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: AppColors.textColor,
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () => Get.toNamed(Routes.ALL_VEHICLES),
                              child: Text(
                                'view_all'.tr,
                                style: TextStyle(
                                  color: AppColors.textColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      BestCarsListWidget(controller: controller),
                      SizedBox(height: 90.h),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
