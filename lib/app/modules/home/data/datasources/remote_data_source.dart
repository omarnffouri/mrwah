import 'package:dartz/dartz.dart';
import 'package:mrwah/app/core/connection/api_constants.dart';
import 'package:mrwah/app/core/connection/dio_client.dart';
import 'package:mrwah/app/core/enums/http_request_type.dart';
import 'package:mrwah/app/core/error/failures.dart';
import 'package:mrwah/app/modules/home/data/models/home_model.dart';
import 'package:mrwah/app/modules/home/data/models/vehicle_model.dart';
import 'package:mrwah/app/modules/home/domain/entities/vehicles_query_params.dart';

abstract class ICarsRemoteDataSource {
  Future<Either<HomeDataModel, Failure>> getHomeData();
  Future<Either<VehiclesModel, Failure>> getVehicles(
      {required VehiclesQueryParams params});
}

class CarsRemoteDataSourceImpl implements ICarsRemoteDataSource {
  @override
  Future<Either<HomeDataModel, Failure>> getHomeData() async {
    try {
      final response = await DioClient.makeRequest(
        url: '${ApiConstants.homeData}?lat=23.70049344&lng=49.96582031',
        method: RequestType.GET,
        parser: (json) => HomeDataModel.fromJson(json),
      );
      return response;
    } catch (e) {
      return Right(
          ServerFailure(title: 'Error', message: e.toString(), code: 500));
    }
  }

  @override
  Future<Either<VehiclesModel, Failure>> getVehicles(
      {required VehiclesQueryParams params}) async {
    try {
      final response = await DioClient.makeRequest(
        url: ApiConstants.getvehicles,
        method: RequestType.GET,
        queryParams: params.toMap(),
        parser: (json) => VehiclesModel.fromJson(json),
      );
      return response;
    } catch (e) {
      return Right(
          ServerFailure(title: 'Error', message: e.toString(), code: 500));
    }
  }
}
