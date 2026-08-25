class User {
  final int? id;
  final String? firstname;
  final String? lastname;
  final String? username;
  final String? email;
  final String? dialCode;
  final String? mobile;
  final int? refBy;
  final String? image;
  final String? countryName;
  final String? countryCode;
  final String? city;
  final String? state;
  final String? zip;
  final String? address;
  final String? late;
  final String? lang;
  final int? status;
  final String? kycRejectionReason;
  final int? kv;
  final int? ev;
  final int? sv;
  final int? profileComplete;
  final String? verCodeSendAt;
  final int? ts;
  final int? tv;
  final String? tsc;
  final String? banReason;
  final String? provider;
  final String? providerId;
  final String? createdAt;
  final String? updatedAt;
  final String? profileImage;
  final String? idFront;
  final String? idBack;
  final String? licence;
  final String? otherFile;
  final List<dynamic>? media;
  final String? token;

  const User({
    this.id,
    this.firstname,
    this.lastname,
    this.username,
    this.email,
    this.dialCode,
    this.mobile,
    this.refBy,
    this.image,
    this.countryName,
    this.countryCode,
    this.city,
    this.state,
    this.zip,
    this.address,
    this.late,
    this.lang,
    this.status,
    this.kycRejectionReason,
    this.kv,
    this.ev,
    this.sv,
    this.profileComplete,
    this.verCodeSendAt,
    this.ts,
    this.tv,
    this.tsc,
    this.banReason,
    this.provider,
    this.providerId,
    this.createdAt,
    this.updatedAt,
    this.profileImage,
    this.idFront,
    this.idBack,
    this.licence,
    this.otherFile,
    this.media,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        firstname: json['firstname'],
        lastname: json['lastname'],
        username: json['username'],
        email: json['email'],
        dialCode: json['dial_code'],
        mobile: json['mobile'],
        refBy: json['ref_by'],
        image: json['image'],
        countryName: json['country_name'],
        countryCode: json['country_code'],
        city: json['city'],
        state: json['state'],
        zip: json['zip'],
        address: json['address'],
        late: json['late'],
        lang: json['lang'],
        status: json['status'],
        kycRejectionReason: json['kyc_rejection_reason'],
        kv: json['kv'],
        ev: json['ev'],
        sv: json['sv'],
        profileComplete: json['profile_complete'],
        verCodeSendAt: json['ver_code_send_at'],
        ts: json['ts'],
        tv: json['tv'],
        tsc: json['tsc'],
        banReason: json['ban_reason'],
        provider: json['provider'],
        providerId: json['provider_id'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        profileImage: json['profile_image'],
        idFront: json['id_front'],
        idBack: json['id_back'],
        licence: json['licence'],
        otherFile: json['other_file'],
        media: json['media'],
        token: json['token'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstname': firstname,
        'lastname': lastname,
        'username': username,
        'email': email,
        'dial_code': dialCode,
        'mobile': mobile,
        'ref_by': refBy,
        'image': image,
        'country_name': countryName,
        'country_code': countryCode,
        'city': city,
        'state': state,
        'zip': zip,
        'address': address,
        'late': late,
        'lang': lang,
        'status': status,
        'kyc_rejection_reason': kycRejectionReason,
        'kv': kv,
        'ev': ev,
        'sv': sv,
        'profile_complete': profileComplete,
        'ver_code_send_at': verCodeSendAt,
        'ts': ts,
        'tv': tv,
        'tsc': tsc,
        'ban_reason': banReason,
        'provider': provider,
        'provider_id': providerId,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'profile_image': profileImage,
        'id_front': idFront,
        'id_back': idBack,
        'licence': licence,
        'other_file': otherFile,
        'media': media,
        'token': token,
      };
}
