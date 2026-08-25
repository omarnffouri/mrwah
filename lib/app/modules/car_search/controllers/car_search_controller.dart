import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CarSearchController extends GetxController {
  final brands = [
    {'label': 'ALL', 'icon': Icons.all_inclusive},
    {'label': 'Ferrari', 'icon': Icons.directions_car},
    {'label': 'Tesla', 'icon': Icons.flash_on},
    {'label': 'BMW', 'icon': Icons.directions_car_filled},
    {'label': 'Lambo', 'icon': Icons.sports_motorsports},
  ];

  RxInt selectedBrand = 0.obs;

  void selectBrand(int index) {
    selectedBrand.value = index;
  }
}
