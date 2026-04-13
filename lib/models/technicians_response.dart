import 'dart:convert';

TechniciansResponse techniciansResponseFromJson(String str) => TechniciansResponse.fromJson(json.decode(str));

String techniciansResponseToJson(TechniciansResponse data) => json.encode(data.toJson());

class TechniciansResponse {
    String? status;
    Data? data;
    String? message;

    TechniciansResponse({
        this.status,
        this.data,
        this.message,
    });

    factory TechniciansResponse.fromJson(Map<String, dynamic> json) => TechniciansResponse(
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
    List<Technician>? technicians;

    Data({
        this.technicians,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        technicians: json["technicians"] == null ? null : List<Technician>.from(json["technicians"].map((x) => Technician.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "technicians": technicians == null ? null : List<dynamic>.from(technicians!.map((x) => x.toJson())),
    };
}

class Technician {
    int? id;
    String? name;

    Technician({
        this.id,
        this.name,
    });

    factory Technician.fromJson(Map<String, dynamic> json) => Technician(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
