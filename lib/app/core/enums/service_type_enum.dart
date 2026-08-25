enum ServiceType {
  carWash,
  carRental,
}

extension ServiceTypeExtension on ServiceType {
  String get apiValue {
    switch (this) {
      case ServiceType.carWash:
        return "car_wash";
      case ServiceType.carRental:
        return "car_rental";
    }
  }

  String get trKey {
    switch (this) {
      case ServiceType.carWash:
        return "car_wash_label";
      case ServiceType.carRental:
        return "car_rental_label";
    }
  }
}
