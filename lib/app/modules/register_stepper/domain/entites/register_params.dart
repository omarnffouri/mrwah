import 'dart:io';

enum UserType { user, partner }

class RegisterParam {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String password;
  final UserType? type;

  final String? city;
  final String? state;

  // Partner fields
  final String? businessName, address, serviceType;

  final double? late;
  final double? lang;

  // Files
  final File? idFront;
  final File? idBack;
  final File? otherFile;

  RegisterParam({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.password,
    this.type,
    this.businessName,
    this.address,
    this.city,
    this.state,
    this.late,
    this.lang,
    this.idFront,
    this.idBack,
    this.otherFile,
    this.serviceType,
  });

  Map<String, dynamic> toJson() {
    if (type == UserType.partner) {
      return {
        'business_name': businessName,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'phone_number': phone,
        'password': password,
        'type': 'partner',
        'late': late,
        'lang': lang,
        'address': address,
        'city': city,
        'state': state,
        'id_front': idFront,
        'id_back': idBack,
        'other_file': otherFile,
        'service_type': serviceType
      };
    } else {
      return {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'phone_number': phone,
        'password': password,
        'city': city,
        'state': state,
      };
    }
  }
}
