import 'package:dartz/dartz.dart';
import 'package:mrwah/app/core/error/failures.dart';

abstract class IResetPasswordRepository {
  Future<Either<String, Failure>> sendResetEmail(String email);
  Future<Either<String, Failure>> verifyResetCode({
    required String email,
    required String code,
  });
  Future<Either<String, Failure>> resetPassword({
    required String token,
    required String email,
    required String password,
    required String passwordConfirmation,
  });
}
