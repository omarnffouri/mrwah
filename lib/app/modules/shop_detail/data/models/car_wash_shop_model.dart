// data/models/car_wash_shop_model.dart
import 'package:mrwah/app/modules/shop_detail/domain/entites/car_wash_entity.dart';

class CarWashShopModel extends CarWashShopEntity {
  CarWashShopModel({
    required super.id,
    required super.name,
    required super.distance,
    required super.rating,
    required super.image,
    required super.lat,
    required super.lng,
    required super.state,
    required super.serviceType,
    required super.plan,
    required super.isBusy,
  });

  factory CarWashShopModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> planList = json['plans'] ?? [];

    final planJson = planList.isNotEmpty ? planList.first : null;
    return CarWashShopModel(
      id: json["id"],
      name: json["name"] ?? "",
      state: json["state"] ?? "",
      serviceType: json["service_type"] ?? "",
      isBusy: json["is_busy"] ?? false,
      distance:
          json["distance"]?.toString() ?? "", // you can calculate it later
      rating: (json["plans"]?.isNotEmpty ?? false) ? 4.5 : 0.0, // sample logic
      image: json["profile_image"] ?? "",
      lat: double.tryParse(json["late"].toString()) ?? 0.0,
      lng: double.tryParse(json["lang"].toString()) ?? 0.0,
      plan: planJson != null
          ? Plans(
              id: planJson['id'] ?? 0,
              name: planJson['name'] ?? '',
              price: planJson['price'] ?? '',
              ownerId: planJson['owner_id'] ?? 0,
            )
          : Plans(id: 0, name: "", ownerId: 0, price: ''),
    );
  }
}
