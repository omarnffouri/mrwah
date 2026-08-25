import 'package:dartz/dartz.dart';
import 'package:mrwah/app/core/error/failures.dart';
import 'package:mrwah/app/modules/login/domain/repo/auth_repository.dart';

class AddDeviceTokenUseCase {
  final IAuthRepository repository;
  AddDeviceTokenUseCase(this.repository);

  Future<Either<bool, Failure>> call(String token) {
    return repository.addDeviceToken(token);
  }
}
