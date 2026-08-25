import 'booking_model.dart';

class PaginatedBookingsModel {
  final List<BookingModel> data;
  final int currentPage;
  final int lastPage;
  final int total;

  PaginatedBookingsModel({
    required this.data,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  factory PaginatedBookingsModel.fromJson(Map<String, dynamic> json) {
    return PaginatedBookingsModel(
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => BookingModel.fromJson(e))
              .toList() ??
          [],
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      total: json['total'] ?? 0,
    );
  }
}
