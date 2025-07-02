import 'dart:convert';

import 'package:ta_mobile/models/device.dart';

class User {
  // Singleton instance
  static final User _instance = User._internal();
  factory User() => _instance;
  User._internal();

  // User properties with proper null handling
  int? id;
  String? name;
  String? email;
  String? phone;
  String? address;
  String? role;
  String? status;
  DateTime? emailVerifiedAt;
  String? twoFactorSecret;
  String? twoFactorRecoveryCodes;
  DateTime? twoFactorConfirmedAt;
  DateTime? lastLoginAt;
  int? currentTeamId;
  String? profilePhotoPath;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<Device> devices = [];

  /// Initialize user with data from API response
  void init(Map<String, dynamic> data) {
    try {
      id = _parseInt(data['id']);
      name = _parseString(data['name']);
      email = _parseString(data['email']);
      phone = _parseString(data['phone']);
      address = _parseString(data['address']);
      role = _parseString(data['role']);
      status = _parseString(data['status']);
      emailVerifiedAt = _parseDateTime(data['email_verified_at']);
      twoFactorSecret = _parseString(data['two_factor_secret']);
      twoFactorRecoveryCodes = _parseString(data['two_factor_recovery_codes']);
      twoFactorConfirmedAt = _parseDateTime(data['two_factor_confirmed_at']);
      lastLoginAt = _parseDateTime(data['last_login_at']);
      currentTeamId = _parseInt(data['current_team_id']);
      profilePhotoPath = _parseString(data['profile_photo_path']);
      createdAt = _parseDateTime(data['created_at']);
      updatedAt = _parseDateTime(data['updated_at']);

      if (data['devices'] != null) {
        if (data['devices'] is List) {
          devices =
              (data['devices'] as List).map((e) => Device.fromJson(e)).toList();
        } else if (data['devices'] is String) {
          try {
            // final decodedDevices = json.decode(data['devices']) as List;
            devices = data['devices'].map((e) => Device.fromJson(e)).toList();
          } catch (e) {
            print('Warning: Failed to decode devices string as JSON: $e');
            devices = []; // Fallback to empty list
          }
        }
      } else {
        devices = [];
      }
    } catch (e) {
      throw Exception(
          'Failed to initialize User: $e\nData: ${data.toString()}');
    }
  }

  List<Device> _parseDartStyleDevices(String devicesString) {
    final List<Device> result = [];

    // 1. Normalisasi string - hapus whitespace berlebihan
    String normalized = devicesString
        .replaceAll('\n', '')
        .replaceAll('\r', '')
        .replaceAll('\t', '')
        .trim();

    // 2. Split per device
    final deviceRegExp = RegExp(r'\{(.*?)\}');
    final matches = deviceRegExp.allMatches(normalized);

    for (final match in matches) {
      try {
        final deviceMap = _parseDartStyleDevice(match.group(0)!);
        result.add(Device.fromJson(deviceMap));
      } catch (e) {
        print('Error parsing device: $e');
      }
    }

    return result;
  }

  Map<String, dynamic> _parseDartStyleDevice(String deviceString) {
    final Map<String, dynamic> result = {};

    // 1. Hilangkan kurung kurawal
    String content = deviceString.substring(1, deviceString.length - 1).trim();

    // 2. Split key-value pairs
    final pairs = content.split(',');

    for (final pair in pairs) {
      final colonIndex = pair.indexOf(':');
      if (colonIndex > 0) {
        final key = pair.substring(0, colonIndex).trim();
        var value = pair.substring(colonIndex + 1).trim();

        // 3. Handle value khusus (datetime, boolean, dll)
        value = _parseDartValue(value);

        result[key] = value;
      }
    }

    return result;
  }

  dynamic _parseDartValue(String value) {
    // Handle string yang mengandung spasi/titik
    if (value.contains(' ') || value.contains('.')) {
      return value;
    }

    // Handle angka
    if (RegExp(r'^-?\d+$').hasMatch(value)) {
      return int.parse(value);
    }

    // Handle boolean
    if (value.toLowerCase() == 'true') return true;
    if (value.toLowerCase() == 'false') return false;

    // Handle string biasa
    return value;
  }

  /// Clear all user data (for logout)
  void clear() {
    id = null;
    name = null;
    email = null;
    phone = null;
    address = null;
    role = null;
    status = null;
    emailVerifiedAt = null;
    twoFactorSecret = null;
    twoFactorRecoveryCodes = null;
    twoFactorConfirmedAt = null;
    lastLoginAt = null;
    currentTeamId = null;
    profilePhotoPath = null;
    createdAt = null;
    updatedAt = null;
    devices.clear();
  }

  /// Check if user is authenticated
  bool get isAuthenticated => id != null && email != null;

  /// Get profile photo URL with fallback to default avatar
  String get profilePhotoUrl {
    if (profilePhotoPath != null && profilePhotoPath!.isNotEmpty) {
      return profilePhotoPath!;
    }
    return 'https://ui-avatars.com/api/?name=${name?.replaceAll(' ', '+') ?? 'user'}&background=random';
  }

  /// Parse string with null handling
  String? _parseString(dynamic value) {
    if (value == null) return null;
    return value.toString();
  }

  /// Parse int with null handling
  int? _parseInt(dynamic value) {
    if (value == null) return null;
    return int.tryParse(value.toString());
  }

  /// Parse DateTime with null handling
  DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    try {
      return DateTime.parse(value.toString()).toLocal();
    } catch (_) {
      return null;
    }
  }

  /// Convert to JSON string
  String toJson() => json.encode(toMap());
// In your User model class
// In your User model class
  void updateFromJson(dynamic jsonData) {
    try {
      // Handle both String and Map input
      final Map<String, dynamic> json = jsonData is String
          ? jsonDecode(jsonData)
          : jsonData as Map<String, dynamic>;

      if (json.containsKey('id')) id = _parseInt(json['id']);
      if (json.containsKey('name')) name = _parseString(json['name']);
      if (json.containsKey('email')) email = _parseString(json['email']);
      if (json.containsKey('phone')) phone = _parseString(json['phone']);
      if (json.containsKey('address')) address = _parseString(json['address']);
      if (json.containsKey('role')) role = _parseString(json['role']);
      if (json.containsKey('status')) status = _parseString(json['status']);
      if (json.containsKey('profile_photo_path')) {
        profilePhotoPath = _parseString(json['profile_photo_path']);
      }
      if (json.containsKey('devices') && json['devices'] != null) {
        devices =
            (json['devices'] as List).map((e) => Device.fromJson(e)).toList();
      }
    } catch (e) {
      throw Exception('Failed to update user from JSON: $e');
    }
  }

  /// Convert to map with proper null handling
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'role': role,
      'status': status,
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'two_factor_secret': twoFactorSecret,
      'two_factor_recovery_codes': twoFactorRecoveryCodes,
      'two_factor_confirmed_at': twoFactorConfirmedAt?.toIso8601String(),
      'last_login_at': lastLoginAt?.toIso8601String(),
      'current_team_id': currentTeamId,
      'profile_photo_path': profilePhotoPath,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'devices': devices.map((device) => device.toMap()).toList(),
    };
  }

  /// Create User from JSON string
  factory User.fromJson(String jsonString) {
    try {
      return User.fromMap(json.decode(jsonString));
    } catch (e) {
      throw Exception('Failed to parse User from JSON: $e');
    }
  }

  factory User.fromMap(Map<String, dynamic> map) {
    final user = User();

    // Convert all null values to empty strings during initialization
    final sanitizedMap = map.map((key, value) {
      if (value == null) {
        return MapEntry(key, '');
      }
      return MapEntry(key, value is String ? value : value.toString());
    });

    user.init(sanitizedMap);
    return user;
  }

  /// Update user with partial data
  void updateFromMap(Map<String, dynamic> map) {
    try {
      if (map.containsKey('id')) id = _parseInt(map['id']);
      if (map.containsKey('name')) name = _parseString(map['name']);
      if (map.containsKey('email')) email = _parseString(map['email']);
      if (map.containsKey('phone')) phone = _parseString(map['phone']);
      if (map.containsKey('address')) address = _parseString(map['address']);
      if (map.containsKey('role')) role = _parseString(map['role']);
      if (map.containsKey('status')) status = _parseString(map['status']);
      if (map.containsKey('devices')) {
        devices =
            (map['devices'] as List).map((e) => Device.fromJson(e)).toList();
      }
    } catch (e) {
      throw Exception('Failed to update User: $e');
    }
  }

  /// Create a copy of the user with updated fields
  User copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? address,
    String? role,
    String? status,
    DateTime? emailVerifiedAt,
    String? twoFactorSecret,
    String? twoFactorRecoveryCodes,
    DateTime? twoFactorConfirmedAt,
    DateTime? lastLoginAt,
    int? currentTeamId,
    String? profilePhotoPath,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<Device>? devices,
  }) {
    return User()
      ..id = id ?? this.id
      ..name = name ?? this.name
      ..email = email ?? this.email
      ..phone = phone ?? this.phone
      ..address = address ?? this.address
      ..role = role ?? this.role
      ..status = status ?? this.status
      ..emailVerifiedAt = emailVerifiedAt ?? this.emailVerifiedAt
      ..twoFactorSecret = twoFactorSecret ?? this.twoFactorSecret
      ..twoFactorRecoveryCodes =
          twoFactorRecoveryCodes ?? this.twoFactorRecoveryCodes
      ..twoFactorConfirmedAt = twoFactorConfirmedAt ?? this.twoFactorConfirmedAt
      ..lastLoginAt = lastLoginAt ?? this.lastLoginAt
      ..currentTeamId = currentTeamId ?? this.currentTeamId
      ..profilePhotoPath = profilePhotoPath ?? this.profilePhotoPath
      ..createdAt = createdAt ?? this.createdAt
      ..updatedAt = updatedAt ?? this.updatedAt
      ..devices = devices ?? List.from(this.devices);
  }

  /// Get formatted creation date
  String get formattedCreatedAt {
    return createdAt?.toLocal().toString().split(' ')[0] ?? 'N/A';
  }

  /// Get formatted last login time
  String get formattedLastLogin {
    if (lastLoginAt == null) return 'Never logged in';
    return 'Last seen ${lastLoginAt!.toLocal().toString().split('.')[0]}';
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, role: $role, devices: ${devices.length})';
  }
}
