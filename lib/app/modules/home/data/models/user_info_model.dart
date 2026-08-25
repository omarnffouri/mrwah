class UserInfoModel {
  final String? email;
  final String? fullName;
  final String? phoneNumber;

  UserInfoModel({
    this.email,
    this.fullName,
    this.phoneNumber,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      email: json['email']?.toString(),
      fullName: json['full_name']?.toString(),
      phoneNumber: json['phone_number']?.toString(),
    );
  }
}
