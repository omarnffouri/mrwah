import 'package:mrwah/app/modules/home/data/models/car_model.dart';
import 'package:mrwah/app/modules/home/data/models/user_info_model.dart';
import '../../domain/entities/booking_entity.dart';

class BookingModel extends BookingEntity {
  BookingModel({
    required super.id,
    super.userInfo,
    super.userId,
    super.vehicleId,
    super.pickLocation,
    super.dropLocation,
    required super.pickTime,
    required super.dropTime,
    required super.price,
    super.trx,
    required super.status,
    super.gender,
    required super.statusText,
    required super.rentalTime,
    required super.bookCarInOffice,
    super.lang,
    super.late,
    required super.createdAt,
    required super.updatedAt,
    super.idFront,
    super.idBack,
    super.license,
    super.vehicle,
    super.paymentUrl,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] ?? 0,
      userInfo: json['user_info'] != null
          ? UserInfoModel.fromJson(json['user_info'])
          : null,
      userId: json['user_id'],
      vehicleId: json['vehicle_id'],
      pickLocation: json['pick_location'],
      dropLocation: json['drop_location'],
      pickTime: json['pick_time'] ?? '',
      dropTime: json['drop_time'] ?? '',
      price: json['price']?.toString() ?? '0',
      trx: _extractTrx(json),
      status: json['status'] ?? 0,
      gender: json['gender']?.toString(),
      statusText: json['status_text']?.toString() ?? '',
      rentalTime: json['rental_time']?.toString() ?? '',
      bookCarInOffice: (json['book_car_in_office'] ?? 0) == 1,
      lang: double.tryParse(json['lang']?.toString() ?? ''),
      late: double.tryParse(json['late']?.toString() ?? ''),
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      idFront: json['id_front']?.toString(),
      idBack: json['id_back']?.toString(),
      license: json['license']?.toString(),
      vehicle:
          json['vehicle'] != null ? CarModel.fromJson(json['vehicle']) : null,
      paymentUrl: _extractPaymentUrl(json),
    );
  }

  static String? _extractPaymentUrl(Map<String, dynamic> json) {
    final directUrl = json['payment_url'] ??
        json['paymentUrl'] ??
        json['payment_link'] ??
        json['paymentLink'] ??
        json['deposit_url'] ??
        json['depositUrl'] ??
        json['url'];

    if (directUrl != null && directUrl.toString().isNotEmpty) {
      return directUrl.toString();
    }

    final deposit = json['deposit'];
    if (deposit is Map<String, dynamic>) {
      final nestedUrl = deposit['url'] ??
          deposit['payment_url'] ??
          deposit['payment_link'] ??
          deposit['link'];
      if (nestedUrl != null && nestedUrl.toString().isNotEmpty) {
        return nestedUrl.toString();
      }
    }

    return null;
  }

  static String? _extractTrx(Map<String, dynamic> json) {
    final directTrx = json['trx'] ??
        json['transaction'] ??
        json['transaction_id'] ??
        json['deposit_id'] ??
        json['payment_id'] ??
        json['reference'];

    if (directTrx != null && directTrx.toString().isNotEmpty) {
      return directTrx.toString();
    }

    final deposit = json['deposit'];
    if (deposit is Map<String, dynamic>) {
      final nestedTrx = deposit['trx'] ??
          deposit['transaction'] ??
          deposit['transaction_id'] ??
          deposit['id'];
      if (nestedTrx != null && nestedTrx.toString().isNotEmpty) {
        return nestedTrx.toString();
      }
    }

    return null;
  }
}
