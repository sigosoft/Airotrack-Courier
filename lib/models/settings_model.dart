class SettingsModel {
  bool? status;
  SettingsData? data;

  SettingsModel({this.status, this.data});

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      status: json['status'],
      data: json['data'] != null ? SettingsData.fromJson(json['data']) : null,
    );
  }
}

class SettingsData {
  List<SettingItem>? settings;

  SettingsData({this.settings});

  factory SettingsData.fromJson(Map<String, dynamic> json) {
    var list = json['settings'] as List?;
    List<SettingItem> settingsList = list != null
        ? list.map((i) => SettingItem.fromJson(i)).toList()
        : [];
    return SettingsData(settings: settingsList);
  }
}

class SettingItem {
  String? maintenanceAndroid;
  String? maintenanceIos;
  String? maintenanceReasonAndroid;
  String? maintenanceReasonIos;
  String? playStoreUpdate;
  String? playStoreVersion;
  String? appStoreUpdate;
  String? appStoreVersion;

  SettingItem({
    this.maintenanceAndroid,
    this.maintenanceIos,
    this.maintenanceReasonAndroid,
    this.maintenanceReasonIos,
    this.playStoreUpdate,
    this.playStoreVersion,
    this.appStoreUpdate,
    this.appStoreVersion,
  });

  factory SettingItem.fromJson(Map<String, dynamic> json) {
    return SettingItem(
      maintenanceAndroid: json['maintenance_android']?.toString(),
      maintenanceIos: json['maintenance_ios']?.toString(),
      maintenanceReasonAndroid: json['maintenance_reason_android']?.toString(),
      maintenanceReasonIos: json['maintenance_reason_ios']?.toString(),
      playStoreUpdate: json['play_store_update']?.toString(),
      playStoreVersion: json['play_store_version']?.toString(),
      appStoreUpdate: json['app_store_update']?.toString(),
      appStoreVersion: json['app_store_version']?.toString(),
    );
  }
}
