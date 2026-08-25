import 'package:dartz/dartz.dart';
import 'package:mrwah/app/core/connection/api_constants.dart';
import 'package:mrwah/app/modules/my_bookings/data/models/paginated_bookings_model.dart';
import '../../../../core/connection/dio_client.dart';
import '../../../../core/enums/http_request_type.dart';
import '../../../../core/error/failures.dart';

abstract class IBookingsRemoteDataSource {
  Future<Either<PaginatedBookingsModel, Failure>> getBookings(
      {required int page});
}

class BookingsRemoteDataSourceImpl implements IBookingsRemoteDataSource {
  @override
  Future<Either<PaginatedBookingsModel, Failure>> getBookings(
      {required int page}) async {
    final response = await DioClient.makeRequest(
      url: '${ApiConstants.bookings}?page=$page',
      method: RequestType.GET,
      parser: (json) => PaginatedBookingsModel.fromJson(json),
    );
    return response;
  }
}
