import 'package:dartz/dartz.dart';
import 'package:mrwah/app/modules/my_bookings/data/models/paginated_bookings_model.dart';
import 'package:mrwah/app/modules/my_bookings/domain/repos/bookings_repository.dart';
import '../../../../core/error/failures.dart';

class GetBookingsUseCase {
  final BookingsRepository repository;
  GetBookingsUseCase(this.repository);

  Future<Either<PaginatedBookingsModel, Failure>> call({required int page}) {
    return repository.getBookings(page: page);
  }
}
