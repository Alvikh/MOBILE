import 'dart:convert';

class Device {
  final int? id;
  final int? ownerId;
  final String name;
  final String deviceId;
  final String type;
  final String building;
  final DateTime? installationDate;
  String status;
  bool state;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  double? temperature;  // Nullable temperature
  double? humidity;     // Nullable humidity

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
    this.temperature,  // Optional temperature
    this.humidity,     // Optional humidity
  });

  factory Device.fromJson(dynamic jsonData) {
    try {
      final Map<String, dynamic> data;
      if (jsonData is String) {
        data = json.decode(jsonData) as Map<String, dynamic>;
      } else if (jsonData is Map<String, dynamic>) {
        data = jsonData;
      } else {
        throw FormatException(
            'Invalid JSON data type for Device: ${jsonData.runtimeType}');
      }

      return Device(
        id: _parseInt(data['id']),
        ownerId: _parseInt(data['owner_id']),
        name: _parseString(data['name']),
        deviceId: _parseString(data['device_id']),
        type: _parseString(data['type']),
        building: _parseString(data['building']),
        installationDate: _parseDateTime(data['installation_date']),
        status: _parseString(data['status']),
        state: _parseBool(data['state']),
        createdAt: _parseDateTime(data['created_at']),
        updatedAt: _parseDateTime(data['updated_at']),
        temperature: _parseDouble(data['temperature']),  // Parse temperature
        humidity: _parseDouble(data['humidity']),        // Parse humidity
      );
    } on FormatException catch (e) {
      print('Invalid device format during Device.fromJson: $e. Data: $jsonData');
      rethrow;
    } catch (e) {
      print('Unexpected error parsing device during Device.fromJson: $e. Data: $jsonData');
      throw Exception('Failed to parse device: $e');
    }
  }

  // New helper method for parsing doubles
  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value.trim());
    }
    return null;
  }

  // Existing helper methods...
  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value.trim());
    return null;
  }

  static String _parseString(dynamic value) {
    if (value == null) return '';
    return value.toString().trim();
  }

  static bool _parseBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) {
      final lowerCaseValue = value.trim().toLowerCase();
      return lowerCaseValue == 'true' ||
          lowerCaseValue == '1' ||
          lowerCaseValue == 'on';
    }
    return false;
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    try {
      return DateTime.parse(value.toString().trim());
    } catch (_) {
      return null;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'owner_id': ownerId,
      'name': name,
      'device_id': deviceId,
      'type': type,
      'building': building,
      'installation_date': installationDate?.toIso8601String(),
      'status': status,
      'state': state,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'temperature': temperature,  // Include temperature in map
      'humidity': humidity,       // Include humidity in map
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'Device(id: $id, name: $name, deviceId: $deviceId, type: $type, '
        'status: $status, state: $state, temperature: $temperature, '
        'humidity: $humidity)';
  }

  // CopyWith method for easy updates
  Device copyWith({
    int? id,
    int? ownerId,
    String? name,
    String? deviceId,
    String? type,
    String? building,
    DateTime? installationDate,
    String? status,
    bool? state,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? temperature,
    double? humidity,
  }) {
    return Device(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      deviceId: deviceId ?? this.deviceId,
      type: type ?? this.type,
      building: building ?? this.building,
      installationDate: installationDate ?? this.installationDate,
      status: status ?? this.status,
      state: state ?? this.state,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      temperature: temperature ?? this.temperature,
      humidity: humidity ?? this.humidity,
    );
  }
}