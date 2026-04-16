import 'dart:convert';

AllocationPreviewResponse allocationPreviewResponseFromJson(String str) => AllocationPreviewResponse.fromJson(json.decode(str));

String allocationPreviewResponseToJson(AllocationPreviewResponse data) => json.encode(data.toJson());

class AllocationPreviewResponse {
    bool? status;
    Data? data;
    String? message;

    AllocationPreviewResponse({
        this.status,
        this.data,
        this.message,
    });

    factory AllocationPreviewResponse.fromJson(Map<String, dynamic> json) => AllocationPreviewResponse(
        status: json["status"] is bool 
            ? json["status"] 
            : json["status"]?.toString() == "true",
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
    int? totalDeviceCount;
    int? repairedDevicesCount;
    int? newDevicesCount;
    int? totalCameraDeviceCount;
    int? repairedCameraDevicesCount;
    int? newCameraDevicesCount;
    int? totalSpeedGovernorDeviceCount;
    int? repairedSpeedGovernorDevicesCount;
    int? newSpeedGovernorDevicesCount;

    Data({
        this.totalDeviceCount,
        this.repairedDevicesCount,
        this.newDevicesCount,
        this.totalCameraDeviceCount,
        this.repairedCameraDevicesCount,
        this.newCameraDevicesCount,
        this.totalSpeedGovernorDeviceCount,
        this.repairedSpeedGovernorDevicesCount,
        this.newSpeedGovernorDevicesCount,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalDeviceCount: json["total_device_count"],
        repairedDevicesCount: json["repaired_devices_count"],
        newDevicesCount: json["new_devices_count"],
        totalCameraDeviceCount: json["total_camera_device_count"],
        repairedCameraDevicesCount: json["repaired_camera_devices_count"],
        newCameraDevicesCount: json["new_camera_devices_count"],
        totalSpeedGovernorDeviceCount: json["total_speed_governor_device_count"],
        repairedSpeedGovernorDevicesCount: json["repaired_speed_governor_devices_count"],
        newSpeedGovernorDevicesCount: json["new_speed_governor_devices_count"],
    );

    Map<String, dynamic> toJson() => {
        "total_device_count": totalDeviceCount,
        "repaired_devices_count": repairedDevicesCount,
        "new_devices_count": newDevicesCount,
        "total_camera_device_count": totalCameraDeviceCount,
        "repaired_camera_devices_count": repairedCameraDevicesCount,
        "new_camera_devices_count": newCameraDevicesCount,
        "total_speed_governor_device_count": totalSpeedGovernorDeviceCount,
        "repaired_speed_governor_devices_count": repairedSpeedGovernorDevicesCount,
        "new_speed_governor_devices_count": newSpeedGovernorDevicesCount,
    };
}
