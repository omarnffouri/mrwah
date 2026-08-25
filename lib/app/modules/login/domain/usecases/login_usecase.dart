import 'package:dartz/dartz.dart';
import 'package:mrwah/app/core/error/failures.dart';
import 'package:mrwah/app/core/usecase/base_use_case.dart';
import 'package:mrwah/app/modules/login/domain/entities/login_params.dart';
import 'package:mrwah/app/modules/login/domain/entities/user.dart';
import 'package:mrwah/app/modules/login/domain/repo/auth_repository.dart';

class LoginUseCase extends BaseUseCase<User, LoginParams> {
  final IAuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<User, Failure>> call(LoginParams params) async {
    return await repository.login(params.email, params.password);
  }
}
