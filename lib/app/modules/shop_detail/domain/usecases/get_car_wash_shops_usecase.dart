// domain/usecases/get_car_wash_shops_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:mrwah/app/modules/shop_detail/domain/entites/car_wash_entity.dart';
import 'package:mrwah/app/modules/shop_detail/domain/repo/shop_repository.dart';
import '../../../../core/error/failures.dart';

class GetCarWashShopsUseCase {
  final ShopRepository repo;

  GetCarWashShopsUseCase(this.repo);

  Future<Either<List<CarWashShopEntity>, Failure>> call({
    required double lat,
    required double lng,
  }) {
    return repo.getCarWashShops(
      lat: lat,
      lng: lng,
    );
  }
}
