import 'package:dartz/dartz.dart';
import 'package:mrwah/app/core/error/failures.dart';
import 'package:mrwah/app/modules/shop_detail/domain/repo/shop_repository.dart';

class CreateCarWashBookingUsecase {
  final ShopRepository repository;

  CreateCarWashBookingUsecase(this.repository);

  Future<Either<String, Failure>> call({
    required int shopId,
    required String bookingTime,
  }) {
    return repository.createBooking(
      shopId: shopId,
      bookingTime: bookingTime,
    );
  }
}
