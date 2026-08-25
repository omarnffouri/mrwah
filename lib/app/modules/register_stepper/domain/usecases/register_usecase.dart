// modules/register_stepper/domain/usecases/register_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:mrwah/app/core/error/failures.dart';
import 'package:mrwah/app/core/usecase/base_use_case.dart';
import 'package:mrwah/app/modules/login/domain/entities/user.dart';
import 'package:mrwah/app/modules/login/domain/repo/auth_repository.dart';
import 'package:mrwah/app/modules/register_stepper/domain/entites/register_params.dart';

class RegisterUseCase extends BaseUseCase<User, RegisterParam> {
  final IAuthRepository repository;
  RegisterUseCase(this.repository);

  @override
  Future<Either<User, Failure>> call(RegisterParam params) async {
    return await repository.register(params);
  }
}
