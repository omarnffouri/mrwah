import 'package:dartz/dartz.dart';
import 'package:mrwah/app/modules/my_bookings/data/models/paginated_bookings_model.dart';
import '../../../../core/error/failures.dart';

abstract class BookingsRepository {
  Future<Either<PaginatedBookingsModel, Failure>> getBookings(
      {required int page});
}
