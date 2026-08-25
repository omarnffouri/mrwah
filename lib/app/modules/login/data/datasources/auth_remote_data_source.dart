import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:mrwah/app/core/connection/api_constants.dart';
import 'package:mrwah/app/core/connection/dio_client.dart';
import 'package:mrwah/app/core/enums/http_request_type.dart';
import 'package:mrwah/app/core/error/failures.dart';
import 'package:mrwah/app/modules/login/domain/entities/user.dart';
import 'package:mrwah/app/modules/register_stepper/domain/entites/register_params.dart';
import '../models/user_model.dart';

abstract class IAuthRemoteDataSource {
  Future<Either<UserModel, Failure>> login(String email, String password);
  Future<Either<void, Failure>> logout();
  Future<Either<void, Failure>> delete(int userId);
  Future<Either<User, Failure>> register(RegisterParam param);
  Future<Either<bool, Failure>> addDeviceToken(String token);
}

class AuthRemoteDataSourceImpl implements IAuthRemoteDataSource {
  @override
  Future<Either<UserModel, Failure>> login(
      String email, String password) async {
    try {
      final response = await DioClient.makeRequest(
        handle401AsAuthFailure: true,
        url: ApiConstants.login,
        method: RequestType.POST,
        data: {
          'email': email,
          'password': password,
          'type': 'user',
        },
        parser: (json) {
          return UserModel.fromJson(json);
        },
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<bool, Failure>> logout() async {
    try {
      final response = await DioClient.makeRequest(
        method: RequestType.POST,
        url: ApiConstants.logout,
        parser: (_) => true,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<bool, Failure>> delete(int userId) async {
    try {
      final response = await DioClient.makeRequest(
        method: RequestType.DELETE,
        url: "${ApiConstants.delete}/$userId",
        parser: (_) => true,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<UserModel, Failure>> register(RegisterParam param) async {
    try {
      // --- Build FormData for file upload ---
      final Map<String, dynamic> data = {
        'first_name': param.firstName,
        'last_name': param.lastName,
        'email': param.email,
        'phone_number': param.phone,
        'password': param.password,
      };

      if (param.type == UserType.partner) {
        data.addAll({
          'service_type': param.serviceType,
          'business_name': param.businessName,
          'address': param.address,
          'city': param.city,
          'state': param.state,
          'late': param.late,
          'lang': param.lang,
          'type': UserType.partner
        });

        if (param.idFront != null) {
          data['id_front'] = await MultipartFile.fromFile(
            param.idFront!.path,
            filename: param.idFront!.path.split('/').last,
          );
        }

        if (param.idBack != null) {
          data['id_back'] = await MultipartFile.fromFile(
            param.idBack!.path,
            filename: param.idBack!.path.split('/').last,
          );
        }

        if (param.otherFile != null) {
          data['other_file'] = await MultipartFile.fromFile(
            param.otherFile!.path,
            filename: param.otherFile!.path.split('/').last,
          );
        }
      }

      final formData = FormData.fromMap(data);

      final response = await DioClient.makeRequest(
        url: ApiConstants.register,
        method: RequestType.POST,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
        parser: (json) => UserModel.fromJson(json),
      );

      return response;
    } catch (e) {
      return Right(ServerFailure(title: 'Error', message: e.toString()));
    }
  }

  @override
  Future<Either<bool, Failure>> addDeviceToken(String token) async {
    try {
      final formData = FormData.fromMap({
        'token': token,
      });

      final response = await DioClient.makeRequest(
        url: ApiConstants.addToken,
        method: RequestType.POST,
        data: formData,
        parser: (json) {
          if (json is Map && json['status'] == "success") {
            return true;
          }
          throw Exception("Unexpected response");
        },
      );

      return response;
    } catch (e) {
      return Right(ServerFailure(title: "Error", message: e.toString()));
    }
  }
}
