import 'package:dartz/dartz.dart';
import 'package:mrwah/app/core/error/failures.dart';
import 'package:mrwah/app/modules/login/domain/repo/auth_repository.dart';

class LogoutUseCase {
  final IAuthRepository repository;

  LogoutUseCase(this.repository);

  Future<Either<void, Failure>> call() async {
    return await repository.logout();
  }
}
