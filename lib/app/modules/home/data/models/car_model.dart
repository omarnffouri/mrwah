// data/models/car_model.dart
import '../../domain/entities/car_entity.dart';

class CarModel extends CarEntity {
  const CarModel({
    required super.id,
    required super.name,
    required super.model,
    required super.price,
    required super.rentalTime,
    required super.details,
    required super.images,
    required super.color,
    required super.transmission,
    required super.fuelType,
    required super.doors,
    super.seats,
    super.location,
    required super.brandName,
    super.brandLogo,
    super.carType,
    super.latitude,
    super.longitude,
    super.specifications,
    super.status,
    super.createdAt,
    super.updatedAt,
    super.owner,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    final ownerJson = json['owner'];

    return CarModel(
      id: json['id'],
      name: json['name'] ?? '',
      model: json['model'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      rentalTime: json['rental_time'] ?? '',
      details: json['details'] ?? '',
      images: List<String>.from(json['v_images'] ?? []),
      color: json['color'] ?? '',
      transmission: json['transmission'] ?? '',
      fuelType: json['fuel_type'] ?? '',
      doors: json['doors'] ?? 0,
      seats: int.tryParse(json['seater']?['number']?.toString() ?? '0'),
      location: json['location']?['name'] ?? 'Unknown',
      brandName: json['brand']?['name'] ?? 'Unknown',
      brandLogo: json['brand']?['logo'],
      carType: json['car_type'],
      latitude: double.tryParse(json['lang']?.toString() ?? ''),
      longitude: double.tryParse(json['late']?.toString() ?? ''),
      specifications: json['specifications'] != null
          ? Map<String, dynamic>.from(json['specifications'])
          : null,
      status: json['status']?.toString(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      owner: ownerJson != null
          ? OwnerEntity(
              id: ownerJson['id'],
              firstname: ownerJson['firstname'] ?? '',
              name: ownerJson['name'] ?? '',
              dialCode: ownerJson['dial_code'] ?? '',
              mobile: ownerJson['mobile'] ?? '',
              city: ownerJson['city'] ?? '',
              state: ownerJson['state'] ?? '',
              image: ownerJson['image'] ?? '',
              profileImage: ownerJson['profile_image'] ?? '',
              lastname: ownerJson['lastname'] ?? '',
              idFront: ownerJson['id_front'],
              idBack: ownerJson['id_back'],
              licence: ownerJson['licence'],
              otherFile: ownerJson['other_file'],
              media: List<String>.from(ownerJson['media'] ?? []),
            )
          : null,
    );
  }
}
