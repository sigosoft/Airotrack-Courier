import 'dart:convert';

CompaniesResponse companiesResponseFromJson(String str) =>
    CompaniesResponse.fromJson(json.decode(str));

String companiesResponseToJson(CompaniesResponse data) =>
    json.encode(data.toJson());

class CompaniesResponse {
  dynamic status;
  List<Company>? data;
  String? message;

  CompaniesResponse({this.status, this.data, this.message});

  factory CompaniesResponse.fromJson(Map<String, dynamic> json) {
    var statusVal = json["status"];
    List<Company>? parsedData;
    if (json["data"] is List) {
      parsedData = List<Company>.from(
        (json["data"] as List).map((x) => Company.fromJson(x)),
      );
    }
    return CompaniesResponse(
      status: statusVal,
      data: parsedData,
      message: json["message"]?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data == null
        ? null
        : List<dynamic>.from(data!.map((x) => x.toJson())),
    "message": message,
  };
}

class Company {
  int? id;
  int? userId;
  String? name;

  Company({this.id, this.userId, this.name});

  factory Company.fromJson(Map<String, dynamic> json) {
    int? parsedId;
    if (json["id"] != null) {
      parsedId = int.tryParse(json["id"].toString());
    } else if (json["company_id"] != null) {
      parsedId = int.tryParse(json["company_id"].toString());
    }

    int? parsedUserId;
    if (json["user_id"] != null) {
      parsedUserId = int.tryParse(json["user_id"].toString());
    }

    String? parsedName =
        json["company_name"] ??
        json["name"] ??
        json["first_name"] ??
        json["username"];

    return Company(id: parsedId, userId: parsedUserId, name: parsedName);
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "company_name": name,
  };
}
