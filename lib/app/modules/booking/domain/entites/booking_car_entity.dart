// domain/entities/booking_entity.dart

class BookingCarEntity {
  final String fullName;
  final String email;
  final String contact;
  final String gender;
  final String rentalType;
  final String pickupDate;
  final String returnDate;
  final bool bookCarInOffice;
  final String? idFrontPath;
  final String? idBackPath;
  final String? licensePath;
  final double lat, lng;

  BookingCarEntity({
    required this.fullName,
    required this.email,
    required this.contact,
    required this.gender,
    required this.rentalType,
    required this.pickupDate,
    required this.returnDate,
    required this.bookCarInOffice,
    required this.lat,
    required this.lng,
    this.idFrontPath,
    this.idBackPath,
    this.licensePath,
  });
}
