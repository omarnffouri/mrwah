import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:mrwah/app/core/helpers/location_picker.dart';

abstract class LocationPickerController {
  RxString get locationAddress;
  RxBool get isMapLoading;

  MapPickerController get mapPickerController;

  CameraPosition get cameraPosition;
  set cameraPosition(CameraPosition position);

  double get selectedLat;
  set selectedLat(double value);

  double get selectedLng;
  set selectedLng(double value);

  void confirmLocation();
}
