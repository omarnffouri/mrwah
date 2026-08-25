import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mrwah/app/core/widgets/app_snack_bar.dart';
import 'package:mrwah/app/core/widgets/emirates_dropdown.dart';
import 'package:mrwah/app/modules/all_vehicles/controllers/all_vehicles_controller.dart';
import 'package:mrwah/app/routes/app_pages.dart';

class CarFiltersSheet extends GetView<AllVehiclesController> {
  const CarFiltersSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          controller.clearFilters();
        }
      },
      child: DraggableScrollableSheet(
        initialChildSize: 0.92,
        maxChildSize: 0.98,
        minChildSize: 0.6,
        builder: (context, scrollController) {
          return Obx(() => Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView(
                  controller: scrollController,
                  children: [
                    const SizedBox(height: 16),
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            icon: const Icon(Icons.close, size: 26),
                            onPressed: () {
                              controller.clearFilters();
                              Navigator.pop(context);
                            }),
                        Text(
                          'filters'.tr,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Color(0xFF0B1437)),
                        ),
                        const SizedBox(width: 36),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Car Type
                    _sectionTitle("type_of_cars".tr),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(controller.carTypes.length, (i) {
                        bool selected = controller.selectedType.value == i;
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                                right: i == controller.carTypes.length - 1
                                    ? 0
                                    : 8),
                            child: GestureDetector(
                              onTap: () {
                                controller.selectedType.value = i;
                                controller.fetchCarCount();
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: selected
                                      ? const Color(0xFF0B1437)
                                      : Colors.white,
                                  border: Border.all(
                                      color: selected
                                          ? const Color(0xFF0B1437)
                                          : Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  controller.carTypes[i],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: selected
                                        ? Colors.white
                                        : const Color(0xFF0B1437),
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 18),
                    // Price Range
                    _sectionTitle("price_range".tr),
                    const SizedBox(height: 2),
                    Obx(() => RangeSlider(
                          min: 10,
                          max: 5100,
                          divisions: 44,
                          values: controller.priceRange.value,
                          activeColor: const Color(0xFF0B1437),
                          inactiveColor: Colors.grey.shade200,
                          onChanged: (values) {
                            controller.priceRange.value = values;
                            controller.fetchCarCount();
                          },
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _priceTag(
                            '\$${controller.priceRange.value.start.toStringAsFixed(0)}'),
                        _priceTag(
                            '\$${controller.priceRange.value.end == 230 ? "230+" : controller.priceRange.value.end.toStringAsFixed(0)}'),
                      ],
                    ),
                    const SizedBox(height: 18),
                    // Rental Time
                    _sectionTitle("rental_time".tr),
                    const SizedBox(height: 7),
                    Row(
                      children:
                          List.generate(controller.rentalTimes.length, (i) {
                        bool selected = controller.selectedRental.value == i;
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                                right: i == controller.rentalTimes.length - 1
                                    ? 0
                                    : 10),
                            child: GestureDetector(
                              onTap: () {
                                controller.selectedRental.value = i;
                                controller.fetchCarCount();
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 11),
                                decoration: BoxDecoration(
                                  color: selected
                                      ? const Color(0xFF0B1437)
                                      : Colors.white,
                                  border: Border.all(
                                      color: selected
                                          ? const Color(0xFF0B1437)
                                          : Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  controller.rentalTimes[i],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: selected
                                        ? Colors.white
                                        : const Color(0xFF0B1437),
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 18),
                    _sectionTitle("emirate".tr),
                    Obx(() => EmiratesDropdown(
                          selectedValue: controller.selectedCity.value,
                          items: controller.uaeCities,
                          onChanged: (value) {
                            controller.selectedCity.value = value ?? '';
                            controller.fetchCarCount();
                          },
                        )),

                    const SizedBox(height: 18),
                    // Sitting Capacity
                    _sectionTitle("siting_capacity".tr),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children:
                          List.generate(controller.capacities.length, (i) {
                        bool selected = controller.selectedCapacity.value == i;
                        return Padding(
                          padding: const EdgeInsets.only(right: 14.0),
                          child: GestureDetector(
                            onTap: () {
                              controller.selectedCapacity.value = i;
                              controller.fetchCarCount();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 9, horizontal: 20),
                              decoration: BoxDecoration(
                                color: selected
                                    ? const Color(0xFF0B1437)
                                    : Colors.white,
                                border: Border.all(
                                    color: selected
                                        ? const Color(0xFF0B1437)
                                        : Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Text(
                                controller.capacities[i],
                                style: TextStyle(
                                    color: selected
                                        ? Colors.white
                                        : const Color(0xFF0B1437),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 18),
                    // Fuel Type
                    _sectionTitle("fuel_type".tr),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: List.generate(controller.fuels.length, (i) {
                        bool selected = controller.selectedFuel.value == i;
                        return Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: GestureDetector(
                            onTap: () {
                              controller.selectedFuel.value = i;
                              controller.fetchCarCount();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 16),
                              decoration: BoxDecoration(
                                color: selected
                                    ? const Color(0xFF0B1437)
                                    : Colors.white,
                                border: Border.all(
                                    color: selected
                                        ? const Color(0xFF0B1437)
                                        : Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                controller.fuels[i],
                                style: TextStyle(
                                    color: selected
                                        ? Colors.white
                                        : const Color(0xFF0B1437),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 28),
                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              controller.clearFilters();
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 17),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                              side: const BorderSide(color: Colors.grey),
                            ),
                            child: Text("clear_all".tr,
                                style: const TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              await controller.applyFilters();

                              if (controller.filteredCarCount.value == 0) {
                                AppSnackBar.info(
                                  'Please adjust your filters and try again.',
                                  title: "No Cars Found",
                                );
                                return;
                              }

                              // ✅ Only navigate if cars are found
                              Navigator.pop(context);
                              Get.toNamed(Routes.ALL_VEHICLES);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 17),
                              backgroundColor: const Color(0xFF0B1437),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                              elevation: 1.5,
                            ),
                            child: controller.isCounting.value
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.2,
                                    ),
                                  )
                                : Text(
                                    'show_cars'.trParams({
                                      'count': controller.filteredCarCount.value
                                          .toString()
                                    }),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ));
        },
      ),
    );
  }

  Widget _sectionTitle(String title) => Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 2),
        child: Text(
          title,
          style: const TextStyle(
              color: Color(0xFF0B1437),
              fontWeight: FontWeight.bold,
              fontSize: 15),
        ),
      );
  Widget _priceTag(String text) => Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: Colors.grey.shade300)),
        child: Text(
          text,
          style: const TextStyle(
              color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 15),
        ),
      );
}
