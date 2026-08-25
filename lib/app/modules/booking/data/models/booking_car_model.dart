// data/models/booking_model.dart

import 'package:mrwah/app/modules/booking/domain/entites/booking_car_entity.dart';

class BookingCarModel extends BookingCarEntity {
  BookingCarModel({
    required super.fullName,
    required super.email,
    required super.contact,
    required super.gender,
    required super.rentalType,
    required super.pickupDate,
    required super.returnDate,
    required super.bookCarInOffice,
    required super.lat,
    required super.lng,
    super.idFrontPath,
    super.idBackPath,
    super.licensePath,
  });

  Map<String, dynamic> toJson() => {
        "full_name": fullName,
        "email": email,
        "phone_number": contact,
        "gender": gender,
        "rental_time": rentalType,
        "pick_time": pickupDate,
        "drop_time": returnDate,
        "book_car_in_office": bookCarInOffice ? 1 : 0,
        "late": lat,
        "lang": lng,
      };
}
