import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:mrwah/app/core/helpers/extensions.dart';
import 'package:mrwah/app/core/resources/app_colors.dart';
import 'package:mrwah/app/core/widgets/background_widget.dart';
import 'package:mrwah/app/core/widgets/custom_header.dart';
import '../controllers/all_vehicles_controller.dart';
import 'package:mrwah/app/modules/home/domain/entities/car_entity.dart';

class AllVehiclesView extends GetView<AllVehiclesController> {
  const AllVehiclesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: Stack(
        children: [
          const BackgroundWidget(),
          Column(
            children: [
              CustomHeader(
                title: 'all_vehicles'.tr,
                showBackButton: true,
                color: AppColors.kDarkBlue,
              ),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return Center(
                      child: SpinKitSpinningLines(
                        color: AppColors.bgColor,
                        size: 45,
                      ),
                    );
                  }

                  if (controller.isError.value) {
                    return Center(
                      child: Text(
                        controller.errorMessage.value,
                        style: const TextStyle(fontSize: 16, color: Colors.red),
                      ),
                    );
                  }

                  if (controller.vehicles.isEmpty) {
                    return const Center(
                      child: Text(
                        'No vehicles available',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }

                  // ✅ Added RefreshIndicator here
                  return RefreshIndicator(
                    color: AppColors.kDarkBlue,
                    backgroundColor: Colors.white,
                    onRefresh: () async {
                      await controller.fetchVehicles(
                        carType: controller.carTypeForApi,
                        seatNumber: controller.seatNumberForApi,
                        minPrice: controller.minPriceForApi,
                        maxPrice: controller.maxPriceForApi,
                        fuelType: controller.fuelTypeForApi,
                        rentalTime: controller.rentalTimeForApi,
                        city: controller.cityForApi,
                      );
                    },
                    child: ListView.builder(
                      physics:
                          const AlwaysScrollableScrollPhysics(), // ensures pull works even when list is short
                      padding: const EdgeInsets.all(16),
                      itemCount: controller.vehicles.length,
                      itemBuilder: (context, index) {
                        final vehicle = controller.vehicles[index];
                        return _VehicleCard(vehicle);
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VehicleCard extends StatelessWidget {
  final CarEntity vehicle;
  const _VehicleCard(this.vehicle);

  @override
  Widget build(BuildContext context) {
    final imageUrl = (vehicle.images.isNotEmpty)
        ? vehicle.images.first
        : 'https://via.placeholder.com/400';
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.applyOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              imageUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AED ${vehicle.price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Color(0xFFD4A017),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${vehicle.brandName} • ${vehicle.name}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0B1443),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (vehicle.seats != null && vehicle.seats! > 0)
                      Text('${'seats'.tr}: ${vehicle.seats}',
                          style: const TextStyle(color: Colors.grey)),
                    if (vehicle.seats != null && vehicle.seats! > 0)
                      const SizedBox(width: 16),
                    Text('${'rental'.tr}: ${vehicle.rentalTime}',
                        style: const TextStyle(color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.grey, size: 16),
                    const SizedBox(width: 4),
                    Text(vehicle.location ?? 'Unknown',
                        style: const TextStyle(color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 12),
                //TODO Add this in bookings view
                // Row(
                //   children: [
                //     Expanded(
                //       child: ElevatedButton.icon(
                //         onPressed: () {},
                //         icon: const Icon(Icons.call, size: 18),
                //         label: const Text('Call'),
                //         style: ElevatedButton.styleFrom(
                //           backgroundColor: const Color(0xFFD4A017),
                //           foregroundColor: Colors.white,
                //           shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(12),
                //           ),
                //           padding: const EdgeInsets.symmetric(vertical: 12),
                //         ),
                //       ),
                //     ),
                //     const SizedBox(width: 12),
                //     Expanded(
                //       child: OutlinedButton.icon(
                //         onPressed: () {},
                //         icon: const Icon(FontAwesomeIcons.whatsapp,
                //             color: Color(0xFF0B1443)),
                //         label: const Text('WhatsApp',
                //             style: TextStyle(color: Color(0xFF0B1443))),
                //         style: OutlinedButton.styleFrom(
                //           side: const BorderSide(color: Color(0xFF0B1443)),
                //           shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(12),
                //           ),
                //           padding: const EdgeInsets.symmetric(vertical: 12),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
