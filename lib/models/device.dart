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

  Device({
    this.id,
    this.ownerId,
    required this.name,
    required this.deviceId,
    required this.type,
    required this.building,
    this.installationDate,
    this.status = 'active',
    this.state = false, // Default to false (OFF)
    this.createdAt,
    this.updatedAt,
  });

  factory Device.fromJson(dynamic jsonData) {
    try {
      final Map<String, dynamic> data;
      // Ensure jsonData is a Map<String, dynamic>
      if (jsonData is String) {
        // If it's a JSON string, decode it
        data = json.decode(jsonData) as Map<String, dynamic>;
      } else if (jsonData is Map<String, dynamic>) {
        // If it's already a map, use it directly
        data = jsonData;
      } else {
        // Handle unexpected types, e.g., if null or other non-map/string
        throw FormatException(
            'Invalid JSON data type for Device: ${jsonData.runtimeType}');
      }

      // Ensure required fields are present and correctly parsed
      return Device(
        id: _parseInt(data['id']),
        ownerId: _parseInt(data['owner_id']),
        name: _parseString(data['name']),
        deviceId: _parseString(data['device_id']),
        type: _parseString(data['type']),
        building: _parseString(data['building']),
        installationDate: _parseDateTime(data['installation_date']),
        status: _parseString(data['status']),
        state: _parseBool(data['state']), // Handle "ON"/"OFF"
        createdAt: _parseDateTime(data['created_at']),
        updatedAt: _parseDateTime(data['updated_at']),
      );
    } on FormatException catch (e) {
      print(
          'Invalid device format during Device.fromJson: $e. Data: $jsonData');
      rethrow; // Propagate specific format errors
    } catch (e) {
      print(
          'Unexpected error parsing device during Device.fromJson: $e. Data: $jsonData');
      throw Exception('Failed to parse device: $e'); // General parsing errors
    }
  }

  // --- Helper parsing methods for Device ---
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
    if (value is int) return value == 1; // Treat 1 as true, 0 as false
    if (value is String) {
      final String lowerCaseValue = value.trim().toLowerCase();
      // Handle "true", "false", "1", "0", "on", "off"
      return lowerCaseValue == 'true' ||
          lowerCaseValue == '1' ||
          lowerCaseValue == 'on';
    }
    return false;
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    try {
      // Handles ISO 8601 strings like "2023-01-20T00:00:00.000000Z"
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
      'state': state, // boolean 'state' is included directly in map
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  // Use toMap() for toJson() for consistency
  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'Device(id: $id, name: $name, deviceId: $deviceId, type: $type, status: $status, state: $state)';
  }
}
