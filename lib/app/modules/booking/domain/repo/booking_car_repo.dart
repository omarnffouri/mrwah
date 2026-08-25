// domain/repositories/booking_repo.dart

import 'package:dartz/dartz.dart';
import 'package:mrwah/app/modules/booking/domain/entites/booking_car_entity.dart';
import '../../../../core/error/failures.dart';

abstract class IBookingCarRepository {
  Future<Either<String, Failure>> createBooking(
      int carId, BookingCarEntity booking);
}
