import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:awesome_dio_interceptor/awesome_dio_interceptor.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:mrwah/app/services/storage_service.dart';

import '../enums/http_request_type.dart';
import '../error/failures.dart';
import 'api_constants.dart';

class DioClient {
  static final BaseOptions _baseOptions = BaseOptions(
    baseUrl: ApiConstants.kServerURL,
    contentType: 'application/json',
    connectTimeout: const Duration(seconds: 120),
    receiveTimeout: const Duration(seconds: 120),
  );
  // ignore: non_constant_identifier_names
  static Dio get DIO_CLIENT => Dio(_baseOptions)
    ..interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
          _addHeaders(options);
          return handler.next(options);
        },
      ),
    )
    ..interceptors.add(
      AwesomeDioInterceptor(
        logRequestTimeout: false,
        logRequestHeaders: false,
        logResponseHeaders: false,
        logger: (log) {
          debugPrint(log);
        },
      ),
    );

  static void _addHeaders(RequestOptions options) {
    options.headers['Content-Type'] = 'application/json';
    options.headers['Accept'] = 'application/json';
    // Add authorization if necessary
    final token = StorageService.token;
    debugPrint('🧾 Token being sent: $token');

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
  }

  static Future<Either<T, Failure>> makeRequest<T>({
    required String url,
    RequestType method = RequestType.GET,
    Object? data,
    Map<String, dynamic>? queryParams,
    Options? options,
    required T Function(dynamic json) parser,
    bool isIsolate = false,
    bool handle401AsAuthFailure = false,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
  }) async {
    try {
      Stopwatch stopwatch = Stopwatch()..start();

      Response<dynamic> response;

      switch (method) {
        case RequestType.POST:
          response = await DIO_CLIENT.post(
            url,
            data: data,
            queryParameters: queryParams,
            options: options,
            cancelToken: cancelToken,
            onSendProgress: onSendProgress,
          );
          break;
        case RequestType.PUT:
          response = await DIO_CLIENT.put(
            url,
            data: data,
            queryParameters: queryParams,
            options: options,
            cancelToken: cancelToken,
            onSendProgress: onSendProgress,
          );
          break;
        case RequestType.PATCH:
          response = await DIO_CLIENT.patch(
            url,
            data: data,
            queryParameters: queryParams,
            options: options,
            cancelToken: cancelToken,
            onSendProgress: onSendProgress,
          );
          break;
        case RequestType.DELETE:
          response = await DIO_CLIENT.delete(
            url,
            data: data,
            queryParameters: queryParams,
            options: options,
            cancelToken: cancelToken,
          );
          break;
        default:
          response = await DIO_CLIENT.get(
            url,
            data: data,
            queryParameters: queryParams,
            options: options,
            cancelToken: cancelToken,
          );
      }

      stopwatch.stop();
      log('$url request time >>> ${stopwatch.elapsedMilliseconds / 1000.0}s');

      // ✅ Handle success (HTTP 200–201)
      if ((response.statusCode ?? 0) >= 200 &&
          (response.statusCode ?? 0) <= 201) {
        return Left(parser(response.data));
      }

      // ❌ Handle 401 Unauthorized globally
      if (response.statusCode == 401) {
        if (handle401AsAuthFailure) {
          final message = _extractMessage(response.data?['message']);
          return Right(ServerFailure(message: message, title: 'Auth Failed'));
        } else {
          await _handleUnauthorized();
          return const Right(ServerFailure(
            message: 'Session expired. Please login again.',
            title: 'Unauthorized',
          ));
        }
      }

      // ❌ Handle non-success codes
      final dataResponse = response.data;
      final message = dataResponse is Map<String, dynamic> &&
              dataResponse.containsKey('message')
          ? _extractMessage(dataResponse['message'])
          : response.statusMessage ?? 'Something went wrong';

      return Right(ServerFailure(message: message, title: 'Error'));
    } on DioException catch (e) {
      // Handle Dio errors
      if (e.response?.statusCode == 401) {
        if (handle401AsAuthFailure) {
          // Do NOT log out or navigate, just return error to show in UI
          final message = _extractMessage(e.response?.data?['message']);
          return Right(ServerFailure(message: message, title: 'Auth Failed'));
        } else {
          await _handleUnauthorized();
          return const Right(ServerFailure(
            message: 'Session expired. Please login again.',
            title: 'Unauthorized',
          ));
        }
      }

      final data = e.response?.data;
      final message =
          data is Map<String, dynamic> && data.containsKey('message')
              ? _extractMessage(data['message'])
              : e.message ?? 'Network error occurred';

      return Right(ServerFailure(
        message: message,
        title: 'Error',
      ));
    } on SocketException {
      return const Right(ServerFailure(
          message: 'No internet connection', title: 'Network Error'));
    } on TimeoutException {
      return const Right(ServerFailure(
          message: 'Request timed out. Please try again.', title: 'Timeout'));
    } catch (e) {
      return Right(
          ServerFailure(message: e.toString(), title: 'Unexpected Error'));
    }
  }
}

String _extractMessage(dynamic messageData) {
  if (messageData is String) return messageData;
  if (messageData is Map) {
    return messageData.entries
        .map((e) => "${e.key}: ${(e.value as List?)?.join(', ') ?? e.value}")
        .join('\n');
  }
  if (messageData is List) {
    return messageData.join(', ');
  }
  return messageData?.toString() ?? 'Something went wrong';
}

Future<void> _handleUnauthorized() async {
  debugPrint('🚪 Unauthorized (401) detected — signing out...');
  await StorageService.clear();

  Future.delayed(const Duration(milliseconds: 300), () {
    Get.offAllNamed('/login');
  });
}
