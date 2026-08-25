import 'package:dartz/dartz.dart';
import 'package:mrwah/app/core/connection/network_info.dart';
import 'package:mrwah/app/core/error/failures.dart';
import 'package:mrwah/app/modules/reset_password/data/datasources/reset_password_remote_data_source.dart';
import 'package:mrwah/app/modules/reset_password/domain/repositories/reset_password_repository.dart';

class ResetPasswordRepositoryImpl implements IResetPasswordRepository {
  final INetworkInfo networkInfo;
  final IResetPasswordRemoteDataSource remoteDataSource;

  ResetPasswordRepositoryImpl({
    required this.networkInfo,
    required this.remoteDataSource,
  });

  @override
  Future<Either<String, Failure>> sendResetEmail(String email) async {
    if (await networkInfo.isConnected) {
      return await remoteDataSource.sendResetEmail(email);
    } else {
      return const Right(
        OfflineFailure(message: 'No Internet, try again later'),
      );
    }
  }

  @override
  Future<Either<String, Failure>> verifyResetCode({
    required String email,
    required String code,
  }) async {
    if (await networkInfo.isConnected) {
      return await remoteDataSource.verifyResetCode(email: email, code: code);
    } else {
      return const Right(
        OfflineFailure(message: 'No Internet, try again later'),
      );
    }
  }

  @override
  Future<Either<String, Failure>> resetPassword({
    required String token,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    if (await networkInfo.isConnected) {
      return await remoteDataSource.resetPassword(
        token: token,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
    } else {
      return const Right(
        OfflineFailure(message: 'No Internet, try again later'),
      );
    }
  }
}
