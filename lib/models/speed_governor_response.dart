import 'dart:convert';

SpeedGovernorResponse speedGovernorResponseFromJson(String str) => SpeedGovernorResponse.fromJson(json.decode(str));

String speedGovernorResponseToJson(SpeedGovernorResponse data) => json.encode(data.toJson());

class SpeedGovernorResponse {
    String? status;
    Data? data;
    String? message;

    SpeedGovernorResponse({
        this.status,
        this.data,
        this.message,
    });

    factory SpeedGovernorResponse.fromJson(Map<String, dynamic> json) => SpeedGovernorResponse(
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
    List<SpeedGovernor>? speedGovernors;

    Data({
        this.speedGovernors,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        speedGovernors: json["speedGovernors"] == null ? [] : List<SpeedGovernor>.from(json["speedGovernors"]!.map((x) => SpeedGovernor.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "speedGovernors": speedGovernors == null ? [] : List<dynamic>.from(speedGovernors!.map((x) => x.toJson())),
    };
}

class SpeedGovernor {
    int? id;
    String? vehicleMake;
    String? vehicleModel;
    String? speed;
    String? testReportNo;
    String? sgTacNumber;
    String? copNumber;
    String? sgModel;
    String? companyName;
    String? sldType;

    SpeedGovernor({
        this.id,
        this.vehicleMake,
        this.vehicleModel,
        this.speed,
        this.testReportNo,
        this.sgTacNumber,
        this.copNumber,
        this.sgModel,
        this.companyName,
        this.sldType,
    });

    factory SpeedGovernor.fromJson(Map<String, dynamic> json) => SpeedGovernor(
        id: json["id"],
        vehicleMake: json["vehicle_make"],
        vehicleModel: json["vehicle_model"],
        speed: json["speed"],
        testReportNo: json["test_report_no"],
        sgTacNumber: json["sg_tac_number"],
        copNumber: json["cop_number"],
        sgModel: json["sg_model"],
        companyName: json["company_name"],
        sldType: json["sld_type"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "vehicle_make": vehicleMake,
        "vehicle_model": vehicleModel,
        "speed": speed,
        "test_report_no": testReportNo,
        "sg_tac_number": sgTacNumber,
        "cop_number": copNumber,
        "sg_model": sgModel,
        "company_name": companyName,
        "sld_type": sldType,
    };

    /// Utility method to get the search string
    String get searchString => "${sgModel ?? ""} ${vehicleModel ?? ""} ${companyName ?? ""}".toLowerCase();
}
