import 'package:get/get.dart';

class CarWashShopEntity {
  final int id;
  final String name;
  final String distance;
  final double rating;
  final String image;
  final double lat;
  final double lng;
  final String state;
  final String serviceType;
  final Plans plan;
  final bool isBusy;

  CarWashShopEntity(
      {required this.id,
      required this.name,
      required this.distance,
      required this.rating,
      required this.image,
      required this.lat,
      required this.lng,
      required this.state,
      required this.serviceType,
      required this.isBusy,
      required this.plan});

  bool get isBusyValue => isBusy;

  /// Convert snake_case → Capital words
  String get formattedServiceType {
    if (serviceType.isEmpty) return "";
    return serviceType.split('_').map((word) => word.capitalize!).join(' ');
  }
}

class Plans {
  final int id, ownerId;
  final String name;
  final String price;

  Plans(
      {required this.id,
      required this.name,
      required this.ownerId,
      required this.price});
}
