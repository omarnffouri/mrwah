import 'package:dartz/dartz.dart';
import 'package:mrwah/app/core/connection/network_info.dart';
import 'package:mrwah/app/core/error/failures.dart';
import 'package:mrwah/app/modules/login/domain/repo/auth_repository.dart';
import 'package:mrwah/app/modules/register_stepper/domain/entites/register_params.dart';

import '../../domain/entities/user.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final INetworkInfo networkInfo;
  final IAuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({
    required this.networkInfo,
    required this.remoteDataSource,
  });

  @override
  Future<Either<User, Failure>> login(String email, String password) async {
    if (await networkInfo.isConnected) {
      return await remoteDataSource.login(email, password);
    } else {
      return const Right(
        OfflineFailure(message: 'No Internet, try again later'),
      );
    }
  }

  @override
  Future<Either<void, Failure>> logout() async {
    if (await networkInfo.isConnected) {
      return await remoteDataSource.logout();
    } else {
      return const Right(
        OfflineFailure(message: 'No Internet, try again later'),
      );
    }
  }

  @override
  Future<Either<void, Failure>> delete(int userId) async {
    if (await networkInfo.isConnected) {
      return await remoteDataSource.delete(userId);
    } else {
      return const Right(
        OfflineFailure(message: 'No Internet, try again later'),
      );
    }
  }

  @override
  Future<Either<User, Failure>> register(RegisterParam param) async {
    if (await networkInfo.isConnected) {
      return await remoteDataSource.register(param);
    } else {
      return const Right(
          OfflineFailure(message: 'No Internet, try again later'));
    }
  }

  @override
  Future<Either<bool, Failure>> addDeviceToken(String token) async {
    if (await networkInfo.isConnected) {
      return await remoteDataSource.addDeviceToken(token);
    } else {
      return const Right(
          OfflineFailure(message: 'No Internet, try again later'));
    }
  }
}
