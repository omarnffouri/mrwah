import 'package:dartz/dartz.dart';
import 'package:mrwah/app/core/connection/network_info.dart';
import 'package:mrwah/app/modules/my_bookings/data/datasource/bookings_remote_datasource.dart';
import 'package:mrwah/app/modules/my_bookings/data/models/paginated_bookings_model.dart';
import 'package:mrwah/app/modules/my_bookings/domain/repos/bookings_repository.dart';
import '../../../../core/error/failures.dart';

class BookingsRepositoryImpl implements BookingsRepository {
  final INetworkInfo networkInfo;
  final IBookingsRemoteDataSource remoteDataSource;
  BookingsRepositoryImpl(
      {required this.networkInfo, required this.remoteDataSource});

  @override
  Future<Either<PaginatedBookingsModel, Failure>> getBookings(
      {required int page}) async {
    if (await networkInfo.isConnected) {
      return await remoteDataSource.getBookings(page: page);
    } else {
      return const Right(
        OfflineFailure(message: 'No Internet, try again later'),
      );
    }
  }
}
