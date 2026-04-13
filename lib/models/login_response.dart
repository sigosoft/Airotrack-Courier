import 'dart:convert';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  String? status;
  Data? data;
  String? message;

  LoginResponse({this.status, this.data, this.message});

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    status: json["status"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data?.toJson(),
    "message": message,
  };
}

class Data {
  Details? details;

  Data({this.details});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    details: json["details"] == null ? null : Details.fromJson(json["details"]),
  );

  Map<String, dynamic> toJson() => {"details": details?.toJson()};
}

class Details {
  int? id;
  String? userName;
  String? name;
  String? email;
  String? mobile;
  dynamic address;
  dynamic companyName;
  int? roleId;
  dynamic passkey;
  int? status;
  int? regStatus;
  int? countryCodeId;
  dynamic profileImg;
  dynamic fcm;
  int? addedBy;
  dynamic updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  String? token;
  String? convertedCreatedAt;

  Details({
    this.id,
    this.userName,
    this.name,
    this.email,
    this.mobile,
    this.address,
    this.companyName,
    this.roleId,
    this.passkey,
    this.status,
    this.regStatus,
    this.countryCodeId,
    this.profileImg,
    this.fcm,
    this.addedBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.token,
    this.convertedCreatedAt,
  });

  factory Details.fromJson(Map<String, dynamic> json) => Details(
    id: json["id"],
    userName: json["user_name"],
    name: json["name"],
    email: json["email"],
    mobile: json["mobile"],
    address: json["address"],
    companyName: json["company_name"],
    roleId: json["role_id"],
    passkey: json["passkey"],
    status: json["status"],
    regStatus: json["reg_status"],
    countryCodeId: json["country_code_id"],
    profileImg: json["profile_img"],
    fcm: json["fcm"],
    addedBy: json["added_by"],
    updatedBy: json["updated_by"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    token: json["token"],
    convertedCreatedAt: json["converted_created_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_name": userName,
    "name": name,
    "email": email,
    "mobile": mobile,
    "address": address,
    "company_name": companyName,
    "role_id": roleId,
    "passkey": passkey,
    "status": status,
    "reg_status": regStatus,
    "country_code_id": countryCodeId,
    "profile_img": profileImg,
    "fcm": fcm,
    "added_by": addedBy,
    "updated_by": updatedBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
    "token": token,
    "converted_created_at": convertedCreatedAt,
  };
}
