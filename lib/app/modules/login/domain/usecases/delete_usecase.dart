import 'package:dartz/dartz.dart';
import 'package:mrwah/app/core/error/failures.dart';
import 'package:mrwah/app/modules/login/domain/repo/auth_repository.dart';

class DeleteUsecase {
  final IAuthRepository repository;

  DeleteUsecase(this.repository);

  Future<Either<void, Failure>> call(int userId) async {
    return await repository.delete(userId);
  }
}
