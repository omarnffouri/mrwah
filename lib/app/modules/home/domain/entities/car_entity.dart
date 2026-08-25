import 'package:equatable/equatable.dart';

class CarEntity extends Equatable {
  final int id;
  final String name;
  final String model;
  final double price;
  final String rentalTime;
  final String details;
  final List<String> images;
  final String? color;
  final String transmission;
  final String fuelType;
  final int doors;
  final int? seats;
  final String? location;
  final String brandName;
  final String? brandLogo;
  final String? carType;
  final double? latitude;
  final double? longitude;
  final Map<String, dynamic>? specifications;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final OwnerEntity? owner;

  const CarEntity({
    required this.id,
    required this.name,
    required this.model,
    required this.price,
    required this.rentalTime,
    required this.details,
    required this.images,
    required this.color,
    required this.transmission,
    required this.fuelType,
    required this.doors,
    this.seats,
    this.location,
    required this.brandName,
    this.brandLogo,
    this.carType,
    this.latitude,
    this.longitude,
    this.specifications,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.owner,
  });

  @override
  List<Object?> get props => [id, name, price];
}

class OwnerEntity extends Equatable {
  final int id;
  final String firstname, name;
  final String lastname;
  final String? idFront;
  final String? idBack;
  final String? licence;
  final String? otherFile;
  final String? image, profileImage;
  final String? city, state;
  final String? dialCode, mobile;
  final List<String> media;

  const OwnerEntity({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.name,
    this.image,
    this.profileImage,
    this.city,
    this.state,
    this.dialCode,
    this.mobile,
    this.idFront,
    this.idBack,
    this.licence,
    this.otherFile,
    this.media = const [],
  });

  @override
  List<Object?> get props => [id, firstname, lastname];
}
