import 'package:dartz/dartz.dart';
import 'package:mrwah/app/core/connection/dio_client.dart';
import 'package:mrwah/app/core/enums/http_request_type.dart';
import 'package:mrwah/app/core/error/failures.dart';
import 'package:dio/dio.dart';
import 'package:mrwah/app/core/connection/api_constants.dart';
import 'package:mrwah/app/modules/shop_detail/data/models/car_wash_shop_model.dart';

abstract class IShopRemoteDataSource {
  Future<Either<String, Failure>> createBooking({
    required int shopId,
    required String bookingTime,
  });
  Future<Either<List<CarWashShopModel>, Failure>> getCarWashShops({
    required double lat,
    required double lng,
  });
}

class ShopRemoteDataSourceImpl implements IShopRemoteDataSource {
  @override
  Future<Either<String, Failure>> createBooking({
    required int shopId,
    required String bookingTime,
  }) async {
    try {
      final data = FormData.fromMap({
        'booking_time': bookingTime,
      });

      final response = await DioClient.makeRequest(
        url: "${ApiConstants.carWashBooking}/$shopId",
        method: RequestType.POST,
        data: data,
        parser: (json) {
          if (json is Map &&
              json['status'] == 'success' &&
              json['url'] != null) {
            return json['url'] as String;
          }
          throw Exception('Unexpected response');
        },
      );

      return response;
    } catch (e) {
      return Right(ServerFailure(title: 'Error', message: e.toString()));
    }
  }

  @override
  Future<Either<List<CarWashShopModel>, Failure>> getCarWashShops({
    required double lat,
    required double lng,
  }) async {
    final response = await DioClient.makeRequest(
      url: ApiConstants.carWashShops,
      method: RequestType.GET,
      queryParams: {
        'lat': lat.toString(),
        'lng': lng.toString(),
      },
      parser: (json) {
        final list = json["data"] as List;
        return list.map((e) => CarWashShopModel.fromJson(e)).toList();
      },
    );

    return response;
  }
}
