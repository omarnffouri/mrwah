import 'package:dartz/dartz.dart';
import 'package:mrwah/app/core/error/failures.dart';
import 'package:mrwah/app/modules/shop_detail/domain/entites/car_wash_entity.dart';

abstract class ShopRepository {
  Future<Either<String, Failure>> createBooking({
    required int shopId,
    required String bookingTime,
  });
  Future<Either<List<CarWashShopEntity>, Failure>> getCarWashShops({
    required double lat,
    required double lng,
  });
}
