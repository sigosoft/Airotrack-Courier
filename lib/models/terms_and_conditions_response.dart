import 'dart:convert';

TermsAndConditionsResponse termsAndConditionsResponseFromJson(String str) => TermsAndConditionsResponse.fromJson(json.decode(str));

String termsAndConditionsResponseToJson(TermsAndConditionsResponse data) => json.encode(data.toJson());

class TermsAndConditionsResponse {
    bool? status;
    Data? data;
    String? message;

    TermsAndConditionsResponse({
        this.status,
        this.data,
        this.message,
    });

    factory TermsAndConditionsResponse.fromJson(Map<String, dynamic> json) => TermsAndConditionsResponse(
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
    TermsAndConditions? termsAndConditions;

    Data({
        this.termsAndConditions,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        termsAndConditions: json["terms_and_conditions"] == null ? null : TermsAndConditions.fromJson(json["terms_and_conditions"]),
    );

    Map<String, dynamic> toJson() => {
        "terms_and_conditions": termsAndConditions?.toJson(),
    };
}

class TermsAndConditions {
    String? title;
    String? content;

    TermsAndConditions({
        this.title,
        this.content,
    });

    factory TermsAndConditions.fromJson(Map<String, dynamic> json) => TermsAndConditions(
        title: json["title"],
        content: json["content"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "content": content,
    };
}
