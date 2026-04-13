import 'dart:convert';

PrivacyPolicyResponse privacyPolicyResponseFromJson(String str) => PrivacyPolicyResponse.fromJson(json.decode(str));

String privacyPolicyResponseToJson(PrivacyPolicyResponse data) => json.encode(data.toJson());

class PrivacyPolicyResponse {
    bool? status;
    Data? data;
    String? message;

    PrivacyPolicyResponse({
        this.status,
        this.data,
        this.message,
    });

    factory PrivacyPolicyResponse.fromJson(Map<String, dynamic> json) => PrivacyPolicyResponse(
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
    PrivacyPolicy? privacyPolicy;

    Data({
        this.privacyPolicy,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        privacyPolicy: json["privacy_policy"] == null ? null : PrivacyPolicy.fromJson(json["privacy_policy"]),
    );

    Map<String, dynamic> toJson() => {
        "privacy_policy": privacyPolicy?.toJson(),
    };
}

class PrivacyPolicy {
    String? title;
    String? content;

    PrivacyPolicy({
        this.title,
        this.content,
    });

    factory PrivacyPolicy.fromJson(Map<String, dynamic> json) => PrivacyPolicy(
        title: json["title"],
        content: json["content"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "content": content,
    };
}
