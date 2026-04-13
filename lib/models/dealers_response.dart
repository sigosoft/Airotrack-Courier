import 'dart:convert';

DealersResponse dealersResponseFromJson(String str) => DealersResponse.fromJson(json.decode(str));

String dealersResponseToJson(DealersResponse data) => json.encode(data.toJson());

class DealersResponse {
    String? status;
    Data? data;
    String? message;

    DealersResponse({
        this.status,
        this.data,
        this.message,
    });

    factory DealersResponse.fromJson(Map<String, dynamic> json) => DealersResponse(
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
    List<Dealer>? dealers;

    Data({
        this.dealers,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        dealers: json["dealers"] == null ? null : List<Dealer>.from(json["dealers"].map((x) => Dealer.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "dealers": dealers == null ? null : List<dynamic>.from(dealers!.map((x) => x.toJson())),
    };
}

class Dealer {
    int? dealerId;
    int? userId;
    String? firstName;
    dynamic lastName;

    Dealer({
        this.dealerId,
        this.userId,
        this.firstName,
        this.lastName,
    });

    factory Dealer.fromJson(Map<String, dynamic> json) => Dealer(
        dealerId: json["dealer_id"],
        userId: json["user_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
    );

    Map<String, dynamic> toJson() => {
        "dealer_id": dealerId,
        "user_id": userId,
        "first_name": firstName,
        "last_name": lastName,
    };
}
