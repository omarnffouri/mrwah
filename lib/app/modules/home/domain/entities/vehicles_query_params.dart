class VehiclesQueryParams {
  final String? carType;
  final int? seatNumber;
  final int? minPrice;
  final int? maxPrice;
  final String? fuelType;
  final String? rentalTime; // NEW
  final String? city; // NEW
  final int? page;

  VehiclesQueryParams({
    this.carType,
    this.seatNumber,
    this.minPrice,
    this.maxPrice,
    this.fuelType,
    this.rentalTime, // NEW
    this.city, // NEW
    this.page,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (carType != null) map['car_type'] = carType;
    if (seatNumber != null) map['seat_number'] = seatNumber;
    if (minPrice != null) map['min_price'] = minPrice;
    if (maxPrice != null) map['max_price'] = maxPrice;
    if (fuelType != null) map['fuel_type'] = fuelType;
    if (rentalTime != null) map['rental_time'] = rentalTime; // NEW
    if (city != null) map['city'] = city; // NEW
    if (page != null) map['page'] = page;
    return map;
  }
}
