import 'package:dartz/dartz.dart';
import 'package:mrwah/app/core/error/failures.dart';
import 'package:mrwah/app/modules/register_stepper/domain/entites/register_params.dart';
import '../entities/user.dart';

abstract class IAuthRepository {
  Future<Either<User, Failure>> login(String email, String password);
  Future<Either<void, Failure>> logout();
  Future<Either<void, Failure>> delete(int userId);
  Future<Either<User, Failure>> register(RegisterParam param);
  Future<Either<bool, Failure>> addDeviceToken(String token);
}
