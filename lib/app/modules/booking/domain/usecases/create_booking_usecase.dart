// domain/usecases/create_booking_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:mrwah/app/modules/booking/domain/entites/booking_car_entity.dart';
import 'package:mrwah/app/modules/booking/domain/repo/booking_car_repo.dart';

import '../../../../core/error/failures.dart';

class CreateBookingUseCase {
  final IBookingCarRepository repository;
  CreateBookingUseCase(this.repository);

  Future<Either<String, Failure>> call(int carId, BookingCarEntity booking) {
    return repository.createBooking(carId, booking);
  }
}
