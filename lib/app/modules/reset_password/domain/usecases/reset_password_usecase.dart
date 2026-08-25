import 'package:dartz/dartz.dart';
import 'package:mrwah/app/core/error/failures.dart';
import 'package:mrwah/app/modules/reset_password/domain/repositories/reset_password_repository.dart';

class ResetPasswordUseCase {
  final IResetPasswordRepository repository;

  ResetPasswordUseCase(this.repository);

  Future<Either<String, Failure>> call({
    required String token,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    return await repository.resetPassword(
      token: token,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
  }
}
