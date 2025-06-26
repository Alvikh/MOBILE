class Device {
  String? id;
  String name;
  String deviceId;
  String type;
  String building;
  DateTime installationDate;
  String status;
  DateTime? createdAt;
  DateTime? updatedAt;

  Device({
    this.id,
    required this.name,
    required this.deviceId,
    required this.type,
    required this.building,
    required this.installationDate,
    this.status = 'active',
    this.createdAt,
    this.updatedAt,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'],
      name: json['name'],
      deviceId: json['device_id'],
      type: json['type'],
      building: json['building'],
      installationDate: DateTime.parse(json['installation_date']),
      status: json['status'] ?? 'active',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'device_id': deviceId,
      'type': type,
      'building': building,
      'installation_date': installationDate.toIso8601String(),
      'status': status,
    };
  }
}
