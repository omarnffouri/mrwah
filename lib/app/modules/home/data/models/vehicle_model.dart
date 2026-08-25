// data/models/vehicles_model.dart

import 'car_model.dart';

class VehiclesModel {
  final int currentPage;
  final List<CarModel> data;
  final String? firstPageUrl;
  final int? from;
  final int? lastPage;
  final String? lastPageUrl;
  final List<LinkModel>? links;
  final String? nextPageUrl;
  final String? path;
  final int? perPage;
  final String? prevPageUrl;
  final int? to;
  final int? total;

  VehiclesModel({
    required this.currentPage,
    required this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  factory VehiclesModel.fromJson(Map<String, dynamic> json) {
    final carsJson = json['cars'];
    return VehiclesModel(
      currentPage: carsJson['current_page'] ?? 1,
      data: (carsJson['data'] as List<dynamic>)
          .map((e) => CarModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      firstPageUrl: carsJson['first_page_url'],
      from: carsJson['from'],
      lastPage: carsJson['last_page'],
      lastPageUrl: carsJson['last_page_url'],
      links: (carsJson['links'] as List<dynamic>?)
          ?.map((e) => LinkModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextPageUrl: carsJson['next_page_url'],
      path: carsJson['path'],
      perPage: (carsJson['per_page'] is String)
          ? int.tryParse(carsJson['per_page'])
          : carsJson['per_page'],
      prevPageUrl: carsJson['prev_page_url'],
      to: carsJson['to'],
      total: carsJson['total'],
    );
  }
}

class LinkModel {
  final String? url;
  final String label;
  final bool active;

  LinkModel({
    this.url,
    required this.label,
    required this.active,
  });

  factory LinkModel.fromJson(Map<String, dynamic> json) {
    return LinkModel(
      url: json['url'],
      label: json['label'].toString(),
      active: json['active'] ?? false,
    );
  }
}
