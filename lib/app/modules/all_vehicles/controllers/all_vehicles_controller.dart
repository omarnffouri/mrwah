import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mrwah/app/core/error/failures.dart';
import 'package:mrwah/app/modules/home/domain/entities/car_entity.dart';
import 'package:mrwah/app/modules/home/domain/entities/vehicles_query_params.dart';
import 'package:mrwah/app/modules/home/domain/usecases/get_vehicles_usecase.dart';
import 'package:mrwah/app/services/injection_service.dart';

class AllVehiclesController extends GetxController {
  final getVehiclesUseCase = sl<GetVehiclesUseCase>();

  // Data
  RxList<CarEntity> vehicles = <CarEntity>[].obs;
  RxBool isLoading = false.obs;
  RxBool isError = false.obs;
  RxString errorMessage = ''.obs;

  // ✅ UAE cities for Emirate filter
  final RxList<String> uaeCities = <String>[
    'Dubai',
    'Abu Dhabi',
    'Sharjah',
    'Ajman',
    'Fujairah',
    'Ras Al Khaimah',
    'Umm Al Quwain',
    'Al Ain',
  ].obs;

// Filters
  RxnInt selectedType = RxnInt(); // null = no type
  RxnInt selectedRental = RxnInt(); // null = no rental time
  Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  RxnInt selectedColor = RxnInt(); // null = no color
  RxnInt selectedCapacity = RxnInt(); // null = no capacity
  RxnInt selectedFuel = RxnInt();
  Rx<RangeValues> priceRange = const RangeValues(20, 5000).obs;
  RxString selectedCity = ''.obs;

  RxInt filteredCarCount = 0.obs;
  RxBool isCounting = false.obs;

  // Constants for filter options
  final carTypes = ['all_cars'.tr, 'regular_cars'.tr, 'luxury_cars'.tr];
  final rentalTimes = ['hour'.tr, 'day'.tr, 'weekly'.tr, 'monthly'.tr];
  final capacities = ['2', '4', '6', '8'];
  final fuels = ['electric'.tr, 'petrol'.tr, 'diesel'.tr, 'hybrid'.tr];

  // 🔹 Computed fields for API
  String? get carTypeForApi {
    if (selectedType.value == null) return null;
    switch (selectedType.value) {
      case 1:
        return 'regular';
      case 2:
        return 'luxury';
      default:
        return null;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchVehicles();
  }

  String? get rentalTimeForApi {
    if (selectedRental.value == null ||
        selectedRental.value! < 0 ||
        selectedRental.value! >= rentalTimes.length) {
      return null;
    }
    return rentalTimes[selectedRental.value!];
  }

  int? get seatNumberForApi {
    if (selectedCapacity.value == null || selectedCapacity.value! <= 0) {
      return null;
    }
    return int.tryParse(capacities[selectedCapacity.value!]);
  }

  String? get fuelTypeForApi {
    if (selectedFuel.value == null || selectedFuel.value! <= 0) {
      return null;
    }
    return fuels[selectedFuel.value!];
  }

  int? get minPriceForApi =>
      priceRange.value.start > 20 ? priceRange.value.start.toInt() : null;

  int? get maxPriceForApi =>
      priceRange.value.end < 5000 ? priceRange.value.end.toInt() : null;

  String? get cityForApi {
    if (selectedCity.value.isNotEmpty) return selectedCity.value;

    return null;
  }

  // 🔹 Build Query Params for API
  VehiclesQueryParams buildSelectedQueryParams() {
    return VehiclesQueryParams(
      carType: carTypeForApi,
      seatNumber: seatNumberForApi,
      minPrice: minPriceForApi,
      maxPrice: maxPriceForApi,
      fuelType: fuelTypeForApi,
      rentalTime: rentalTimeForApi,
      city: cityForApi,
      page: 1,
    );
  }

  Future<void> fetchCarCount() async {
    isCounting.value = true;
    final params = buildSelectedQueryParams();

    final result = await getVehiclesUseCase(params: params);
    result.fold((data) {
      filteredCarCount.value = data.total ?? 0;
    }, (failure) {
      filteredCarCount.value = 0;
    });

    isCounting.value = false;
  }

  // 🔹 Apply filters and fetch vehicles
  Future<void> applyFilters() async {
    final params = buildSelectedQueryParams();
    await fetchVehicles(
      carType: params.carType,
      seatNumber: params.seatNumber,
      minPrice: params.minPrice,
      maxPrice: params.maxPrice,
      fuelType: params.fuelType,
      rentalTime: params.rentalTime,
      city: params.city,
      page: params.page ?? 1,
    );
  }

  // 🔹 Fetch vehicles with filters
  Future<void> fetchVehicles({
    String? carType,
    int? seatNumber,
    int? minPrice,
    int? maxPrice,
    String? fuelType,
    String? rentalTime,
    String? city,
    int page = 1,
  }) async {
    isLoading.value = true;
    isError.value = false;

    final params = VehiclesQueryParams(
      carType: carType,
      seatNumber: seatNumber,
      minPrice: minPrice,
      maxPrice: maxPrice,
      fuelType: fuelType,
      rentalTime: rentalTime,
      city: city,
      page: page,
    );

    final result = await getVehiclesUseCase(params: params);

    result.fold(
      (data) {
        // ✅ You can also locally filter by owner.city or owner.state
        final filteredList = (city != null && city.isNotEmpty)
            ? data.data.where((car) {
                final ownerCity = (car.owner?.city ?? '').toLowerCase();
                final ownerState = (car.owner?.state ?? '').toLowerCase();
                return ownerCity.contains(city.toLowerCase()) ||
                    ownerState.contains(city.toLowerCase());
              }).toList()
            : data.data;

        vehicles.value = filteredList;
        isError.value = false;
      },
      (Failure failure) {
        isError.value = true;
        errorMessage.value = failure.message;
      },
    );

    isLoading.value = false;
  }

  void clearFilters() {
    selectedType.value = null;
    selectedRental.value = null;
    selectedDate.value = null;
    selectedColor.value = null;
    selectedCapacity.value = null;
    selectedFuel.value = null;

    selectedCity.value = '';
    filteredCarCount.value = 0;
    fetchVehicles();
  }
}
