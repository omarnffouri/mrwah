import 'package:mrwah/app/modules/home/data/models/car_model.dart';
import 'package:mrwah/app/modules/home/data/models/user_info_model.dart';

class BookingEntity {
  final int id;
  final UserInfoModel? userInfo;
  final int? userId;
  final int? vehicleId;
  final String? pickLocation;
  final String? dropLocation;
  final String pickTime;
  final String dropTime;
  final String price;
  final String? trx;
  final int status;
  final String? gender;
  final String statusText;
  final String rentalTime;
  final bool bookCarInOffice;
  final double? lang;
  final double? late;
  final String createdAt;
  final String updatedAt;
  final String? idFront;
  final String? idBack;
  final String? license;
  final CarModel? vehicle;
  final String? paymentUrl;

  BookingEntity({
    required this.id,
    this.userInfo,
    this.userId,
    this.vehicleId,
    this.pickLocation,
    this.dropLocation,
    required this.pickTime,
    required this.dropTime,
    required this.price,
    this.trx,
    required this.status,
    this.gender,
    required this.statusText,
    required this.rentalTime,
    required this.bookCarInOffice,
    this.lang,
    this.late,
    required this.createdAt,
    required this.updatedAt,
    this.idFront,
    this.idBack,
    this.license,
    this.vehicle,
    this.paymentUrl,
  });

  String get dateRangeOnly {
    final start = pickTime.split(' ').first;
    final end = dropTime.split(' ').first;
    return '$start - $end';
  }

  String get cleanPrice {
    final parsed = double.tryParse(price);
    if (parsed == null) return price;
    return parsed.toStringAsFixed(2).replaceAll(RegExp(r'\.0+$|0+$'), '');
  }
}
