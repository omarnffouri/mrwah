import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mrwah/app/core/resources/app_colors.dart';
import 'package:mrwah/app/core/widgets/app_button.dart';
import 'package:mrwah/app/core/widgets/app_snack_bar.dart';
import 'package:mrwah/app/core/widgets/brand_footer.dart';
import 'package:mrwah/app/modules/shop_detail/views/controllers/shop_detail_controller.dart';
import 'package:mrwah/app/modules/shop_detail/views/widgets/book_service_bottom_sheet.dart';

class ShopDetailView extends GetView<ShopDetailController> {
  const ShopDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            children: [
              /// Main shop image (dynamic)
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                child: controller.shop.image.isNotEmpty
                    ? Image.network(
                        controller.shop.image,
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        "assets/images/wash_car.jpg",
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
              ),

              /// Back button
              Positioned(
                top: 40,
                left: 16,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: AppColors.bgColor,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ],
          ),

          /// CONTENT
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Category + Rating
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.bgColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    controller.shop.formattedServiceType,
                                    style: TextStyle(
                                      color: AppColors.mainColor,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.star,
                                        color: Colors.orange, size: 18),
                                    Text(
                                      " ${controller.shop.rating} (${355} reviews)",
                                      style:
                                          TextStyle(color: AppColors.bgColor),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            /// SHOP NAME
                            Text(
                              controller.shop.name,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.mainColor,
                              ),
                            ),
                            const SizedBox(height: 6),

                            /// Address
                            Text(
                              controller.shop.state,
                              style: TextStyle(
                                color: AppColors.bgColor,
                              ),
                            ),
                            const SizedBox(height: 20),

                            /// Tabs
                            DefaultTabController(
                              length: 3,
                              child: Column(
                                children: [
                                  TabBar(
                                    labelColor: AppColors.bgColor,
                                    unselectedLabelColor: AppColors.mainColor,
                                    indicatorColor: AppColors.bgColor,
                                    tabs: [
                                      Tab(text: 'about'.tr),
                                      Tab(text: 'services'.tr),
                                      Tab(text: 'location'.tr),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 170,
                                    child: TabBarView(
                                      children: [
                                        /// ABOUT
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 24),
                                          child: Text(
                                            "Car wash service based in ${controller.shop.state}",
                                            style: TextStyle(
                                                color: AppColors.bgColor),
                                          ),
                                        ),

                                        /// SERVICES
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 24),
                                          child: Text(
                                              " * ${controller.shop.formattedServiceType}"),
                                        ),

                                        /// LOCATION TAB (Google Map)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 12),
                                          child: GestureDetector(
                                            onTap: controller.openMap,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: AbsorbPointer(
                                                child: SizedBox(
                                                  height: 150,
                                                  width: double.infinity,
                                                  child: GoogleMap(
                                                    initialCameraPosition:
                                                        CameraPosition(
                                                      target: LatLng(
                                                        controller.shop.lat,
                                                        controller.shop.lng,
                                                      ),
                                                      zoom: 14,
                                                    ),
                                                    myLocationButtonEnabled:
                                                        false,
                                                    zoomControlsEnabled: false,
                                                    compassEnabled: false,
                                                    tiltGesturesEnabled: false,
                                                    scrollGesturesEnabled:
                                                        false,
                                                    zoomGesturesEnabled: false,
                                                    rotateGesturesEnabled:
                                                        false,
                                                    mapToolbarEnabled: false,
                                                    markers: {
                                                      Marker(
                                                        markerId: const MarkerId(
                                                            "shop_location"),
                                                        position: LatLng(
                                                          controller.shop.lat,
                                                          controller.shop.lng,
                                                        ),
                                                      ),
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            /// PUSH BUTTON TO BOTTOM
                            const SizedBox(height: 20),
                            const Spacer(),

                            AppButton(
                              onPressed: () => controller.shop.isBusyValue
                                  ? AppSnackBar.info(
                                      'This shop is currently busy',
                                    )
                                  : _openBookingSheet(context),
                              text: "book_service_now".tr,
                              backgroundColor: AppColors.mainColor,
                            ),

                            const SizedBox(height: 16),

                            /// Brand Footer
                            const BrandFooter(),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _openBookingSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: BookServiceBottomSheet(controller: controller),
      ),
    );
  }
}
