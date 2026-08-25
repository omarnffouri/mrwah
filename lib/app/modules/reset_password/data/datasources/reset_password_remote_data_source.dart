import 'package:dartz/dartz.dart';
import 'package:mrwah/app/core/connection/api_constants.dart';
import 'package:mrwah/app/core/connection/dio_client.dart';
import 'package:mrwah/app/core/enums/http_request_type.dart';
import 'package:mrwah/app/core/error/failures.dart';

abstract class IResetPasswordRemoteDataSource {
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

class ResetPasswordRemoteDataSourceImpl
    implements IResetPasswordRemoteDataSource {
  @override
  Future<Either<String, Failure>> sendResetEmail(String email) async {
    try {
      final response = await DioClient.makeRequest(
        url: ApiConstants.sendResetPasswordEmail,
        method: RequestType.POST,
        data: {'value': email},
        parser: (json) => _parseMessage(
          json,
          fallback: 'Verification code sent to your email.',
        ),
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<String, Failure>> verifyResetCode({
    required String email,
    required String code,
  }) async {
    try {
      final response = await DioClient.makeRequest(
        url: ApiConstants.verifyResetPasswordCode,
        method: RequestType.POST,
        data: {
          'email': email,
          'code': code,
        },
        parser: (json) => _parseMessage(
          json,
          fallback: 'Code verified successfully.',
        ),
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<String, Failure>> resetPassword({
    required String token,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await DioClient.makeRequest(
        url: ApiConstants.resetPassword,
        method: RequestType.POST,
        data: {
          'token': token,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
        parser: (json) => _parseMessage(
          json,
          fallback: 'Password reset successfully.',
        ),
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  String _parseMessage(dynamic json, {required String fallback}) {
    if (json is Map && json['message'] != null) {
      return json['message'].toString();
    }

    if (json is String && json.isNotEmpty) {
      return json;
    }

    return fallback;
  }
}
