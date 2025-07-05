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
          devices = _parseDartDebugStringToListOfMaps(data['devices']);
        } else {
          devices = [];
        }
      }
    } catch (e) {
      throw Exception(
          'Failed to initialize User: $e\nData: ${data.toString()}');
    }
  }

  List<Device> _parseDartDebugStringToListOfMaps(String devicesString) {
    final List<Device> result = [];
    String content = devicesString.trim();

    if (content.startsWith('[') && content.endsWith(']')) {
      content = content.substring(1, content.length - 1).trim();
    }

    final List<String> rawDeviceStrings = _splitDartListStringRobust(content);

    for (final rawDeviceString in rawDeviceStrings) {
      if (rawDeviceString.isEmpty) continue;

      String deviceContent = rawDeviceString;
      if (!deviceContent.startsWith('{')) deviceContent = '{' + deviceContent;
      if (!deviceContent.endsWith('}')) deviceContent = deviceContent + '}';

      try {
        final jsonString = _convertDartDebugMapStringToJson(deviceContent);
        final Map<String, dynamic> deviceMap = json.decode(jsonString);
        result.add(Device.fromJson(deviceMap));
      } catch (e) {
        print('Error parsing device: $e. Raw: "$rawDeviceString"');
      }
    }
    return result;
  }

  String _convertDartDebugMapStringToJson(String dartMapString) {
    String content =
        dartMapString.substring(1, dartMapString.length - 1).trim();
    final StringBuffer jsonBuffer = StringBuffer('{');
    bool firstPair = true;
    List<String> pairs = _splitDartMapStringRobust(content);

    for (String pair in pairs) {
      pair = pair.trim();
      if (pair.isEmpty) continue;

      int colonIndex = pair.indexOf(':');
      if (colonIndex == -1) continue;

      String key = pair.substring(0, colonIndex).trim();
      String value = pair.substring(colonIndex + 1).trim();

      if (!firstPair) jsonBuffer.write(',');
      jsonBuffer.write('"${key}"');
      jsonBuffer.write(':');

      if (value.toLowerCase() == 'null') {
        jsonBuffer.write('null');
      } else if (value.toLowerCase() == 'true' ||
          value.toLowerCase() == 'false') {
        jsonBuffer.write(value.toLowerCase());
      } else if (int.tryParse(value) != null ||
          double.tryParse(value) != null) {
        jsonBuffer.write(value);
      } else {
        jsonBuffer.write('"${value.replaceAll('"', '\\"')}"');
      }
      firstPair = false;
    }

    jsonBuffer.write('}');
    return jsonBuffer.toString();
  }

  List<String> _splitDartMapStringRobust(String mapContent) {
    List<String> parts = [];
    int balance = 0;
    int start = 0;

    for (int i = 0; i < mapContent.length; i++) {
      String char = mapContent[i];

      if (char == '{' || char == '[')
        balance++;
      else if (char == '}' || char == ']')
        balance--;
      else if (char == ',' && balance == 0) {
        parts.add(mapContent.substring(start, i).trim());
        start = i + 1;
      }
    }
    parts.add(mapContent.substring(start).trim());
    return parts.where((p) => p.isNotEmpty).toList();
  }

  List<String> _splitDartListStringRobust(String listContent) {
    List<String> parts = [];
    int bracketCount = 0;
    int lastSplitIndex = 0;

    for (int i = 0; i < listContent.length; i++) {
      if (listContent[i] == '{')
        bracketCount++;
      else if (listContent[i] == '}') {
        bracketCount--;
        if (bracketCount == 0 &&
            (i + 1 < listContent.length && listContent[i + 1] == ',')) {
          parts.add(listContent.substring(lastSplitIndex, i + 1).trim());
          lastSplitIndex = i + 2;
        }
      }
    }
    String lastPart = listContent.substring(lastSplitIndex).trim();
    if (lastPart.isNotEmpty) parts.add(lastPart);
    return parts;
  }

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

  bool get isAuthenticated => id != null && email != null;

  String get profilePhotoUrl {
    if (profilePhotoPath != null && profilePhotoPath!.isNotEmpty) {
      return profilePhotoPath!;
    }
    return 'https://ui-avatars.com/api/?name=${name?.replaceAll(' ', '+') ?? 'user'}&background=random';
  }

  String? _parseString(dynamic value) => value?.toString();
  int? _parseInt(dynamic value) =>
      value != null ? int.tryParse(value.toString()) : null;
  DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    try {
      return DateTime.parse(value.toString()).toLocal();
    } catch (_) {
      return null;
    }
  }

  String toJson() => json.encode(toMap());

  void updateFromJson(dynamic jsonData) {
    try {
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

  factory User.fromJson(String jsonString) {
    try {
      return User.fromMap(json.decode(jsonString));
    } catch (e) {
      throw Exception('Failed to parse User from JSON: $e');
    }
  }

  factory User.fromMap(Map<String, dynamic> map) {
    final user = User();
    user.init(map);
    return user;
  }

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

  String get formattedCreatedAt {
    return createdAt?.toLocal().toString().split(' ')[0] ?? 'N/A';
  }

  String get formattedLastLogin {
    if (lastLoginAt == null) return 'Never logged in';
    return 'Last seen ${lastLoginAt!.toLocal().toString().split('.')[0]}';
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, role: $role, devices: ${devices.length})';
  }
}
