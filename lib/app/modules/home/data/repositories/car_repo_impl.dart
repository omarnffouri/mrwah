// data/repositories/cars_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:mrwah/app/core/connection/network_info.dart';
import 'package:mrwah/app/core/error/failures.dart';
import 'package:mrwah/app/modules/home/data/datasources/remote_data_source.dart';
import 'package:mrwah/app/modules/home/data/models/home_model.dart';
import 'package:mrwah/app/modules/home/data/models/vehicle_model.dart';
import 'package:mrwah/app/modules/home/domain/entities/vehicles_query_params.dart';
import 'package:mrwah/app/modules/home/domain/repositories/cars_repo.dart';

class CarsRepositoryImpl implements ICarsRepository {
  final INetworkInfo networkInfo;
  final ICarsRemoteDataSource remoteDataSource;

  CarsRepositoryImpl({
    required this.networkInfo,
    required this.remoteDataSource,
  });

  @override
  Future<Either<HomeDataModel, Failure>> getHomeData() async {
    if (await networkInfo.isConnected) {
      return await remoteDataSource.getHomeData();
    } else {
      return const Right(
        OfflineFailure(message: 'No Internet, try again later'),
      );
    }
  }

  @override
  Future<Either<VehiclesModel, Failure>> getVehicles(
      {required VehiclesQueryParams params}) async {
    if (await networkInfo.isConnected) {
      return await remoteDataSource.getVehicles(params: params);
    } else {
      return const Right(
          OfflineFailure(message: 'No Internet, try again later'));
    }
  }
}
