import 'package:dartz/dartz.dart';
import 'package:mrwah/app/core/error/failures.dart';
import 'package:mrwah/app/modules/home/data/models/home_model.dart';
import 'package:mrwah/app/modules/home/data/models/vehicle_model.dart';
import 'package:mrwah/app/modules/home/domain/entities/vehicles_query_params.dart';

abstract class ICarsRepository {
  Future<Either<HomeDataModel, Failure>> getHomeData();
  Future<Either<VehiclesModel, Failure>> getVehicles(
      {required VehiclesQueryParams params});
}
