import 'package:dartz/dartz.dart';
import 'package:mrwah/app/core/connection/network_info.dart';
import 'package:mrwah/app/core/error/failures.dart';
import 'package:mrwah/app/modules/shop_detail/data/datasource/shop_remote_data_source.dart';
import 'package:mrwah/app/modules/shop_detail/domain/entites/car_wash_entity.dart';
import 'package:mrwah/app/modules/shop_detail/domain/repo/shop_repository.dart';

class ShopRepositoryImpl implements ShopRepository {
  final INetworkInfo networkInfo;
  final IShopRemoteDataSource remoteDataSource;

  ShopRepositoryImpl(
      {required this.networkInfo, required this.remoteDataSource});

  @override
  Future<Either<String, Failure>> createBooking({
    required int shopId,
    required String bookingTime,
  }) {
    return remoteDataSource.createBooking(
      shopId: shopId,
      bookingTime: bookingTime,
    );
  }

  @override
  Future<Either<List<CarWashShopEntity>, Failure>> getCarWashShops({
    required double lat,
    required double lng,
  }) async {
    final result = await remoteDataSource.getCarWashShops(
      lat: lat,
      lng: lng,
    );

    return result.fold(
      (shops) => Left(shops), // success
      (failure) => Right(failure),
    );
  }
}
