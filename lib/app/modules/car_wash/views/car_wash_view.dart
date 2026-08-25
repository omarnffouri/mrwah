import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mrwah/app/core/resources/app_colors.dart';
import 'package:mrwah/app/modules/car_wash/controllers/car_wash_controller.dart';
import 'package:mrwah/app/modules/car_wash/views/widgets/shop_card.dart';

class CarWashView extends GetView<CarWashController> {
  const CarWashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Obx(() {
            if (controller.currentPosition.value == null) {
              return Center(
                child: SpinKitSpinningLines(
                  color: AppColors.bgColor,
                  size: 28,
                ),
              );
            }

            return GoogleMap(
              initialCameraPosition: CameraPosition(
                target: controller.initialPosition.value,
                zoom: 14,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: false,
              onMapCreated: (GoogleMapController mapController) {
                controller.mapController = mapController;
              },

              // NEW — when user moves map
              onCameraMove: (position) {
                controller.onMapMoved(position.target);
              },

              // Optional but good to have
              onCameraIdle: () {
                // Camera stopped. Debounce will decide when to call API.
              },

              markers: controller.shops.map((shop) {
                final position = LatLng(shop.lat, shop.lng);

                return Marker(
                  markerId: MarkerId(shop.id.toString()),
                  position: position,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueAzure,
                  ),
                  infoWindow: InfoWindow(
                    title: shop.name,
                    snippet: shop.distance,
                  ),
                );
              }).toSet(),
            );
          }),

          Positioned(
            top: 60,
            right: 15,
            child: FloatingActionButton(
              backgroundColor: AppColors.mainColor,
              mini: true,
              onPressed: () {
                controller.fetchShops(); // or the function you already use
              },
              child: const Icon(Icons.refresh, color: Colors.white),
            ),
          ),

          /// SHOP LIST
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 180,
              child: Obx(() {
                if (controller.isDraggingMap.value ||
                    controller.isLoadingShops.value) {
                  return Center(
                    child: SpinKitPulse(
                      color: AppColors.bgColor,
                      size: 40,
                    ),
                  );
                }
                if (controller.shops.isEmpty) {
                  return Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            spreadRadius: 2,
                          )
                        ],
                      ),
                      child: Text(
                        "No car wash shops available here",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.bgColor,
                        ),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: controller.shops.length,
                  itemBuilder: (context, index) {
                    final shop = controller.shops[index];

                    return Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: ShopCard(shop: shop),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
