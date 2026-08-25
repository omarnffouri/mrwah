import 'package:dartz/dartz.dart';
import 'package:mrwah/app/modules/booking/data/datasource/booking_car_remote_data_source.dart';
import 'package:mrwah/app/modules/booking/domain/entites/booking_car_entity.dart';
import 'package:mrwah/app/modules/booking/domain/repo/booking_car_repo.dart';
import '../../../../core/connection/network_info.dart';
import '../../../../core/error/failures.dart';

class BookingCarRepositoryImpl implements IBookingCarRepository {
  final INetworkInfo networkInfo;
  final IBookingCarRemoteDataSource remoteDataSource;

  BookingCarRepositoryImpl({
    required this.networkInfo,
    required this.remoteDataSource,
  });

  @override
  Future<Either<String, Failure>> createBooking(
      int carId, BookingCarEntity booking) async {
    if (await networkInfo.isConnected) {
      return await remoteDataSource.createBooking(carId, booking);
    } else {
      return const Right(
          OfflineFailure(message: 'No Internet, try again later'));
    }
  }
}
