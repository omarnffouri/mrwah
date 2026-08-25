// data/models/home_data_model.dart

import 'package:mrwah/app/modules/home/data/models/brands_model.dart';

import 'car_model.dart';

class HomeDataModel {
  final List<Brand> brands;
  final List<CarModel> bestCars;
  final List<CarModel>? nearbyCars;

  HomeDataModel({
    required this.brands,
    required this.bestCars,
    required this.nearbyCars,
  });

  factory HomeDataModel.fromJson(Map<String, dynamic> json) {
    return HomeDataModel(
      brands: (json['brands'] as List).map((b) => Brand.fromJson(b)).toList(),
      bestCars:
          (json['best_cars'] as List).map((c) => CarModel.fromJson(c)).toList(),
      nearbyCars: json['near_by'] != null
          ? (json['near_by'] as List).map((c) => CarModel.fromJson(c)).toList()
          : null,
    );
  }
}
