import 'package:dartz/dartz.dart';
import 'package:mrwah/app/core/error/failures.dart';
import 'package:mrwah/app/modules/home/data/models/vehicle_model.dart';
import 'package:mrwah/app/modules/home/domain/entities/vehicles_query_params.dart';
import 'package:mrwah/app/modules/home/domain/repositories/cars_repo.dart';

class GetVehiclesUseCase {
  final ICarsRepository repository;
  GetVehiclesUseCase(this.repository);

  Future<Either<VehiclesModel, Failure>> call(
      {required VehiclesQueryParams params}) {
    return repository.getVehicles(params: params);
  }
}
