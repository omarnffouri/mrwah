import 'package:dartz/dartz.dart';
import 'package:mrwah/app/core/error/failures.dart';
import 'package:mrwah/app/modules/reset_password/domain/repositories/reset_password_repository.dart';

class SendResetEmailUseCase {
  final IResetPasswordRepository repository;

  SendResetEmailUseCase(this.repository);

  Future<Either<String, Failure>> call(String email) async {
    return await repository.sendResetEmail(email);
  }
}
