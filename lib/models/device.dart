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
  static DateTime? _parseDate(dynamic value) {
    if (value == null || value.toString().isEmpty) return null;
    try {
      return DateTime.parse(value.toString());
    } catch (_) {
      return null;
    }
  }

  factory Device.fromJson(dynamic jsonData) {
    try {
      // Convert input to Map
      final Map<String, dynamic> data = jsonData is Map<String, dynamic>
          ? jsonData
          : json.decode(jsonData.toString());

      // Validate required fields
      if (data['id'] == null ||
          data['owner_id'] == null ||
          data['name'] == null ||
          data['device_id'] == null) {
        throw FormatException('Missing required device fields');
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
      );
    } on FormatException catch (e) {
      print('Invalid device format: $e');
      rethrow;
    } catch (e) {
      print('Unexpected error parsing device: $e');
      throw Exception('Failed to parse device: $e');
    }
  }
  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static String _parseString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) return value;
    if (value is String) return value.toLowerCase() == 'true' || value == '1';
    if (value is int) return value == 1;
    return false;
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    try {
      return DateTime.parse(value.toString());
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
    };
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
