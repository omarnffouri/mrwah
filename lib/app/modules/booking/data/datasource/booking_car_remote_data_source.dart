// data/datasources/booking_remote_data_source.dart

import 'package:dartz/dartz.dart';
import 'package:mrwah/app/core/enums/http_request_type.dart';
import 'package:mrwah/app/modules/booking/data/models/booking_car_model.dart';
import 'package:mrwah/app/modules/booking/domain/entites/booking_car_entity.dart';
import '../../../../core/error/failures.dart';
import 'package:dio/dio.dart';

import '../../../../core/connection/api_constants.dart';
import '../../../../core/connection/dio_client.dart';

abstract class IBookingCarRemoteDataSource {
  /// Left = success (payment URL), Right = Failure
  Future<Either<String, Failure>> createBooking(
      int carId, BookingCarEntity booking);
}

class BookingCarRemoteDataSourceImpl implements IBookingCarRemoteDataSource {
  @override
  Future<Either<String, Failure>> createBooking(
      int carId, BookingCarEntity booking) async {
    try {
      // Prepare form data from the BookingCarModel
      final formData = FormData.fromMap({
        ...BookingCarModel(
          fullName: booking.fullName,
          email: booking.email,
          contact: booking.contact,
          gender: booking.gender,
          rentalType: booking.rentalType,
          pickupDate: booking.pickupDate,
          returnDate: booking.returnDate,
          bookCarInOffice: booking.bookCarInOffice,
          lat: booking.lat,
          lng: booking.lng,
        ).toJson(),
        if (booking.idFrontPath != null)
          "id_front": await MultipartFile.fromFile(
            booking.idFrontPath!,
            filename: "id_front.jpg",
          ),
        if (booking.idBackPath != null)
          "id_back": await MultipartFile.fromFile(
            booking.idBackPath!,
            filename: "id_back.jpg",
          ),
        if (booking.licensePath != null)
          "license": await MultipartFile.fromFile(
            booking.licensePath!,
            filename: "license.jpg",
          ),
      });

      // We let DioClient.makeRequest handle errors and we parse the JSON ourselves
      final response = await DioClient.makeRequest(
        url: "${ApiConstants.bookCar}/$carId",
        method: RequestType.POST,
        data: formData,
        // Keep raw json so we can inspect "status" and "url"
        parser: (json) => json,
      );

      // response is Either<dynamic, Failure>
      // In your style: Left = success, Right = failure
      return response.fold<Either<String, Failure>>(
        (json) {
          try {
            if (json is Map<String, dynamic> &&
                json["status"] == "success" &&
                json["url"] is String &&
                (json["url"] as String).isNotEmpty) {
              final String paymentUrl = json["url"] as String;
              // SUCCESS → return payment URL
              return Left(paymentUrl);
            }

            return const Right(
              ServerFailure(
                title: "Booking Failed",
                message: "Invalid response from server",
                code: 500,
              ),
            );
          } catch (e) {
            return const Right(
              ServerFailure(
                title: "Booking Failed",
                message: "Unexpected response format",
                code: 500,
              ),
            );
          }
        },
        (failure) {
          // DioClient already gave us a Failure
          return Right(failure);
        },
      );
    } catch (e) {
      return Right(
        ServerFailure(
          title: "Error",
          message: e.toString(),
          code: 500,
        ),
      );
    }
  }
}
