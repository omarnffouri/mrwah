import 'package:dartz/dartz.dart';
import 'package:mrwah/app/core/error/failures.dart';
import 'package:mrwah/app/modules/reset_password/domain/repositories/reset_password_repository.dart';

class VerifyResetCodeUseCase {
  final IResetPasswordRepository repository;

  VerifyResetCodeUseCase(this.repository);

  Future<Either<String, Failure>> call({
    required String email,
    required String code,
  }) async {
    return await repository.verifyResetCode(email: email, code: code);
  }
}
