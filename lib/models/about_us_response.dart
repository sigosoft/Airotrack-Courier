import 'dart:convert';

AboutUsResponse aboutUsResponseFromJson(String str) => AboutUsResponse.fromJson(json.decode(str));

String aboutUsResponseToJson(AboutUsResponse data) => json.encode(data.toJson());

class AboutUsResponse {
    bool? status;
    Data? data;
    String? message;

    AboutUsResponse({
        this.status,
        this.data,
        this.message,
    });

    factory AboutUsResponse.fromJson(Map<String, dynamic> json) => AboutUsResponse(
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
    AboutUs? aboutUs;

    Data({
        this.aboutUs,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        aboutUs: json["about_us"] == null ? null : AboutUs.fromJson(json["about_us"]),
    );

    Map<String, dynamic> toJson() => {
        "about_us": aboutUs?.toJson(),
    };
}

class AboutUs {
    String? title;
    String? content;

    AboutUs({
        this.title,
        this.content,
    });

    factory AboutUs.fromJson(Map<String, dynamic> json) => AboutUs(
        title: json["title"],
        content: json["content"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "content": content,
    };
}
