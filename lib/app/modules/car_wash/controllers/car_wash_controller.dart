// presentation/controllers/car_wash_controller.dart
import 'dart:async';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mrwah/app/core/widgets/app_snack_bar.dart';
import 'package:mrwah/app/modules/shop_detail/domain/entites/car_wash_entity.dart';
import 'package:mrwah/app/modules/shop_detail/domain/usecases/get_car_wash_shops_usecase.dart';
import 'package:mrwah/app/services/injection_service.dart';

class CarWashController extends GetxController {
  final getCarWashShopsUseCase = sl<GetCarWashShopsUseCase>();

  GoogleMapController? mapController;

  final isLoadingShops = false.obs;
  final isDraggingMap = false.obs;

  final shops = <CarWashShopEntity>[].obs;

  /// User location
  final currentPosition = Rxn<LatLng>();

  /// Default position = Dubai
  final initialPosition = const LatLng(25.276987, 55.296249).obs;

  @override
  void onInit() {
    super.onInit();
    determinePosition();
    fetchShops();
  }

  // ---------------------------------------------------------
  // 🔵 GET CURRENT LOCATION
  // ---------------------------------------------------------
  Future<void> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        AppSnackBar.info(
          'Please enable GPS.',
          title: "Location Disabled",
        );
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          AppSnackBar.info(
            'Location permission required.',
            title: "Permission Denied",
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        AppSnackBar.info(
          'Enable location permission from settings.',
          title: "Permission Blocked",
        );

        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 0,
        ),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException("Location request timed out"),
      );

      currentPosition.value = LatLng(position.latitude, position.longitude);
      initialPosition.value = currentPosition.value!;

      if (mapController != null) {
        mapController!.animateCamera(
          CameraUpdate.newLatLng(currentPosition.value!),
        );
      }
    } catch (e) {
      AppSnackBar.error(
        e.toString(),
        title: "Location Error",
      );
      currentPosition.value = initialPosition.value;
    }
  }

  // ---------------------------------------------------------
  // 🔵 FETCH CAR WASH SHOPS FROM API
  // ---------------------------------------------------------
  Future<void> fetchShops() async {
    isLoadingShops.value = true;

    LatLng? pos = currentPosition.value;

    pos ??= initialPosition.value;

    final result = await getCarWashShopsUseCase(
      lat: 24.43466000,
      lng: 54.4130710,
    );

    result.fold(
      (data) => shops.assignAll(data),
      (failure) => AppSnackBar.error(
        failure.message,
        title: "Error",
      ),
    );
    isLoadingShops.value = false;
  }

  Timer? _debounce;

  void onMapMoved(LatLng newCenter) {
    isDraggingMap.value = true; // user is dragging
    currentPosition.value = newCenter;

    // Cancel any previous timer
    _debounce?.cancel();

    // Wait 1 second after movement stops
    _debounce = Timer(const Duration(seconds: 1), () {
      isDraggingMap.value = false;

      fetchShops(); // call API after stop moving
    });
  }
}
