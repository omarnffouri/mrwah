// domain/usecases/get_best_cars_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:mrwah/app/core/error/failures.dart';
import 'package:mrwah/app/modules/home/data/models/home_model.dart';
import 'package:mrwah/app/modules/home/domain/repositories/cars_repo.dart';

class GetBestCarsUseCase {
  final ICarsRepository repository;

  GetBestCarsUseCase(this.repository);

  Future<Either<HomeDataModel, Failure>> call() async {
    return await repository.getHomeData();
  }
}
