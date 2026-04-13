import 'dart:convert';

ContactUsResponse contactUsResponseFromJson(String str) => ContactUsResponse.fromJson(json.decode(str));

String contactUsResponseToJson(ContactUsResponse data) => json.encode(data.toJson());

class ContactUsResponse {
    bool? status;
    Data? data;
    String? message;

    ContactUsResponse({
        this.status,
        this.data,
        this.message,
    });

    factory ContactUsResponse.fromJson(Map<String, dynamic> json) => ContactUsResponse(
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
    ContactUs? contactUs;

    Data({
        this.contactUs,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        contactUs: json["contact_us"] == null ? null : ContactUs.fromJson(json["contact_us"]),
    );

    Map<String, dynamic> toJson() => {
        "contact_us": contactUs?.toJson(),
    };
}

class ContactUs {
    String? address;
    String? email;
    String? mobileNumber;

    ContactUs({
        this.address,
        this.email,
        this.mobileNumber,
    });

    factory ContactUs.fromJson(Map<String, dynamic> json) => ContactUs(
        address: json["address"],
        email: json["email"],
        mobileNumber: json["mobile_number"],
    );

    Map<String, dynamic> toJson() => {
        "address": address,
        "email": email,
        "mobile_number": mobileNumber,
    };
}
