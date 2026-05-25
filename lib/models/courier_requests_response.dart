import 'dart:convert';

CourierRequestsResponse courierRequestsResponseFromJson(String str) =>
    CourierRequestsResponse.fromJson(json.decode(str));

String courierRequestsResponseToJson(CourierRequestsResponse data) =>
    json.encode(data.toJson());

class CourierRequestsResponse {
  bool? status;
  Data? data;
  String? message;

  CourierRequestsResponse({this.status, this.data, this.message});

  factory CourierRequestsResponse.fromJson(Map<String, dynamic> json) =>
      CourierRequestsResponse(
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
  List<CourierRequest>? courierRequests;

  Data({this.courierRequests});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    courierRequests: json["courier_requests"] == null
        ? null
        : List<CourierRequest>.from(
            json["courier_requests"].map((x) => CourierRequest.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "courier_requests": courierRequests == null
        ? null
        : List<dynamic>.from(courierRequests!.map((x) => x.toJson())),
  };
}

class CourierRequest {
  int? id;
  int? dealerId;
  int? technicianId;
  int? customerId;
  int? totalDevices;
  int? noOfNewGps;
  int? noOfServiceGps;
  int? noOfNewCameras;
  int? noOfServiceCameras;
  int? noOfNewSpeedGovernors;
  int? noOfServiceSpeedGovernors;
  String? invoiceNumber;
  String? invoice;
  int? status;
  int? courierStatus;
  int? paymentStatus;
  int? addedUser;
  int? updatedUser;
  String? createdAt;
  String? updatedAt;
  int? courierId;
  int? courierUserType;
  String? courierUserName;
  String? courierUserContact;
  int? courierUserId;
  String? addedUserName;
  String? updatedUserName;

  CourierRequest({
    this.id,
    this.dealerId,
    this.technicianId,
    this.customerId,
    this.totalDevices,
    this.noOfNewGps,
    this.noOfServiceGps,
    this.noOfNewCameras,
    this.noOfServiceCameras,
    this.noOfNewSpeedGovernors,
    this.noOfServiceSpeedGovernors,
    this.invoiceNumber,
    this.invoice,
    this.status,
    this.courierStatus,
    this.paymentStatus,
    this.addedUser,
    this.updatedUser,
    this.createdAt,
    this.updatedAt,
    this.courierId,
    this.courierUserType,
    this.courierUserName,
    this.courierUserContact,
    this.courierUserId,
    this.addedUserName,
    this.updatedUserName,
  });

  factory CourierRequest.fromJson(Map<String, dynamic> json) => CourierRequest(
    id: json["id"],
    dealerId: json["dealer_id"],
    technicianId: json["technician_id"],
    customerId: json["customer_id"],
    totalDevices: json["total_devices"],
    noOfNewGps: json["no_of_new_gps"],
    noOfServiceGps: json["no_of_service_gps"],
    noOfNewCameras: json["no_of_new_cameras"],
    noOfServiceCameras: json["no_of_service_cameras"],
    noOfNewSpeedGovernors: json["no_of_new_speed_governors"],
    noOfServiceSpeedGovernors: json["no_of_service_speed_governors"],
    invoiceNumber: json["invoice_number"]?.toString(),
    invoice: json["invoice"]?.toString(),
    status: json["status"],
    courierStatus: json["courier_status"],
    paymentStatus: json["payment_status"],
    addedUser: json["added_user"],
    updatedUser: json["updated_user"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    courierId: json["courier_id"],
    courierUserType: json["courier_user_type"],
    courierUserName: json["courier_user_name"],
    courierUserContact: json["courier_user_contact"]?.toString(),
    courierUserId: json["courier_user_id"],
    addedUserName: json["added_user_name"],
    updatedUserName: json["updated_user_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "dealer_id": dealerId,
    "technician_id": technicianId,
    "customer_id": customerId,
    "total_devices": totalDevices,
    "no_of_new_gps": noOfNewGps,
    "no_of_service_gps": noOfServiceGps,
    "no_of_new_cameras": noOfNewCameras,
    "no_of_service_cameras": noOfServiceCameras,
    "no_of_new_speed_governors": noOfNewSpeedGovernors,
    "no_of_service_speed_governors": noOfServiceSpeedGovernors,
    "invoice_number": invoiceNumber,
    "invoice": invoice,
    "status": status,
    "courier_status": courierStatus,
    "payment_status": paymentStatus,
    "added_user": addedUser,
    "updated_user": updatedUser,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "courier_id": courierId,
    "courier_user_type": courierUserType,
    "courier_user_name": courierUserName,
    "courier_user_contact": courierUserContact,
    "courier_user_id": courierUserId,
    "added_user_name": addedUserName,
    "updated_user_name": updatedUserName,
  };
}
