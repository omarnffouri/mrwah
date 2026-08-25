import 'package:get/get.dart';
import 'package:mrwah/app/modules/my_bookings/domain/entities/booking_entity.dart';
import 'package:mrwah/app/modules/my_bookings/domain/usecases/get_bookings_usecase.dart';
import 'package:mrwah/app/services/injection_service.dart';
import 'package:mrwah/app/core/widgets/app_snack_bar.dart';
import 'package:mrwah/app/modules/booking/views/widgets/payment_webview.dart';
import 'package:mrwah/app/services/payment_link_storage.dart';

class BookingsController extends GetxController {
  final getBookingsUseCase = sl<GetBookingsUseCase>();

  RxList<BookingEntity> bookings = <BookingEntity>[].obs;
  RxInt page = 1.obs;
  RxBool isLoading = false.obs;
  RxBool isLastPage = false.obs;

  static const _paymentHost = "https://mrwah.org";

  @override
  void onInit() {
    super.onInit();
    fetchBookings();
  }

  Future<void> fetchBookings({bool loadMore = false}) async {
    if (isLoading.value) return;
    isLoading.value = true;

    final result = await getBookingsUseCase(page: page.value);

    // ✅ Since DioClient returns Either<PaginatedBookingsModel, Failure>,
    // the success is on the LEFT side (first param of fold)
    result.fold(
      (paginated) {
        if (loadMore) {
          bookings.addAll(paginated.data);
        } else {
          bookings.value = paginated.data;
        }
        _sortBookings();
        isLastPage.value = paginated.currentPage >= paginated.lastPage;
      },
      (failure) {
        // Optional: log or handle failure here
        print("❌ Failed to fetch bookings: ${failure.message}");
      },
    );

    isLoading.value = false;
  }

  void loadMore() {
    if (!isLastPage.value && !isLoading.value) {
      page.value++;
      fetchBookings(loadMore: true);
    }
  }

  void _sortBookings() {
    bookings.sort(
      (a, b) => a.statusText.toLowerCase().compareTo(
            b.statusText.toLowerCase(),
          ),
    );
  }

  String? paymentUrlFor(BookingEntity booking) {
    if (booking.paymentUrl != null && booking.paymentUrl!.isNotEmpty) {
      return booking.paymentUrl;
    }

    // Check cached links from a previous booking submission
    final cached = PaymentLinkStorage.getForId(booking.trx);
    if (cached != null && cached.isNotEmpty) {
      return cached;
    }
    final cachedById = PaymentLinkStorage.getForId(booking.id.toString());
    if (cachedById != null && cachedById.isNotEmpty) {
      return cachedById;
    }

    // Fallback: try to reconstruct from transaction (trx)
    if (booking.trx != null && booking.trx!.isNotEmpty) {
      final trx = booking.trx!;
      if (booking.userId != null) {
        return "$_paymentHost/gateways/deposits/rent/$trx/u/${booking.userId}/m";
      }
      return "$_paymentHost/user/deposit?trx=$trx";
    }

    return null;
  }

  void openPayment(BookingEntity booking) {
    final url = paymentUrlFor(booking);

    if (url == null || url.isEmpty) {
      AppSnackBar.error("Payment link not available");
      return;
    }

    final amount = booking.cleanPrice.isNotEmpty
        ? "${booking.cleanPrice} AED"
        : null;
    final total = _computeTotal(amount);
    final rentalDate =
        booking.pickTime.isNotEmpty && booking.dropTime.isNotEmpty
            ? "${booking.pickTime.split(' ').first} - ${booking.dropTime.split(' ').first}"
            : booking.dateRangeOnly;

    Get.to(
      () => PaymentWebView(
        url: url,
        bookingType: "car",
        bookingName: booking.vehicle?.name,
        rentalDate: rentalDate,
        amount: amount,
        total: total,
      ),
    );
  }

  String? _computeTotal(String? amountLabel) {
    if (amountLabel == null) return null;
    final value = double.tryParse(amountLabel.replaceAll(RegExp(r'[^0-9.]'), ''));
    if (value == null) return null;
    return "${(value + 15).toStringAsFixed(2)} AED";
  }
}
