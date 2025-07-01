class Device {
  final int? id;
  final String? ownerId;
  final String name;
  final String deviceId;
  final String type;
  final String building;
  final DateTime? installationDate;
  String status;
  final bool state;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Device({
    this.id,
    this.ownerId,
    required this.name,
    required this.deviceId,
    required this.type,
    required this.building,
    this.installationDate,
    this.status = 'active',
    this.state = false,
    this.createdAt,
    this.updatedAt,
  });
  static DateTime? _tryParseDate(dynamic value) {
    if (value == null || value.toString().isEmpty) return null;
    try {
      return DateTime.parse(value.toString());
    } catch (_) {
      return null;
    }
  }

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? ''),
      ownerId: json['owner_id']?.toString(),
      name: json['name']?.toString() ?? '',
      deviceId: json['device_id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      building: json['building']?.toString() ?? '',
      installationDate: _tryParseDate(json['installation_date']),
      status: json['status']?.toString() ?? 'active',
      createdAt: _tryParseDate(json['created_at']),
      updatedAt: _tryParseDate(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'owner_id': ownerId,
      'name': name,
      'device_id': deviceId,
      'type': type,
      'building': building,
      'installation_date': installationDate?.toIso8601String(),
      'status': status,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
