import 'dart:convert';

import 'package:ta_mobile/models/device.dart';

class User {
  // Singleton instance
  static final User _instance = User._internal();
  factory User() => _instance;
  User._internal(); // Private constructor

  // User properties
  int? id;
  String? name;
  String? email;
  dynamic phone;
  dynamic address;
  String? role;
  dynamic emailVerifiedAt;
  dynamic twoFactorSecret;
  dynamic twoFactorRecoveryCodes;
  dynamic twoFactorConfirmedAt;
  dynamic lastLoginAt;
  dynamic currentTeamId;
  dynamic profilePhotoPath;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? status;
  List<Device> devices = []; // Initialize empty list

  /// Initialize user with data from API response
  void init(Map<String, dynamic> data) {
    id = data['id'] as int?;
    name = data['name'] as String?;
    email = data['email'] as String?;
    phone = data['phone'];
    address = data['address'];
    role = data['role'] as String?;
    emailVerifiedAt = data['email_verified_at'];
    twoFactorSecret = data['two_factor_secret'];
    twoFactorRecoveryCodes = data['two_factor_recovery_codes'];
    twoFactorConfirmedAt = data['two_factor_confirmed_at'];
    lastLoginAt = data['last_login_at'];
    currentTeamId = data['current_team_id'];
    profilePhotoPath = data['profile_photo_path'];
    createdAt = data['created_at'] == null
        ? null
        : DateTime.parse(data['created_at'] as String);
    updatedAt = data['updated_at'] == null
        ? null
        : DateTime.parse(data['updated_at'] as String);
    status = data['status'] as String?;

    // Initialize devices list
    if (data['devices'] != null) {
      devices = (data['devices'] as List)
          .map((deviceJson) => Device.fromJson(deviceJson))
          .toList();
    } else {
      devices = [];
    }
  }

  /// Clear all user data (for logout)
  void clear() {
    id = null;
    name = null;
    email = null;
    phone = null;
    address = null;
    role = null;
    emailVerifiedAt = null;
    twoFactorSecret = null;
    twoFactorRecoveryCodes = null;
    twoFactorConfirmedAt = null;
    lastLoginAt = null;
    currentTeamId = null;
    profilePhotoPath = null;
    createdAt = null;
    updatedAt = null;
    status = null;
    devices.clear();
  }

  /// Check if user is authenticated
  bool get isAuthenticated => id != null && email != null;

  /// Get profile photo URL with fallback to default avatar
  String get profilePhotoUrl {
    if (profilePhotoPath != null) {
      return profilePhotoPath.toString();
    }
    return 'https://ui-avatars.com/api/?name=${name?.replaceAll(' ', '+')}&background=random';
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, devices: ${devices.length})';
  }

  factory User.fromMap(Map<String, dynamic> data) {
    final user = User();
    user.init(data);
    return user;
  }

  void updateFromJson(Map<String, dynamic> json) {
    if (json.containsKey('id')) id = json['id'] as int?;
    if (json.containsKey('name')) name = json['name'] as String?;
    if (json.containsKey('email')) email = json['email'] as String?;
    if (json.containsKey('phone')) phone = json['phone'] as String?;
    if (json.containsKey('address')) address = json['address'] as String?;
    if (json.containsKey('role')) role = json['role'] as String?;
    if (json.containsKey('devices')) {
      devices = (json['devices'] as List)
          .map((deviceJson) => Device.fromJson(deviceJson))
          .toList();
    }

    // ... (rest of your existing updateFromJson code)
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
        'role': role,
        'email_verified_at': emailVerifiedAt,
        'two_factor_secret': twoFactorSecret,
        'two_factor_recovery_codes': twoFactorRecoveryCodes,
        'two_factor_confirmed_at': twoFactorConfirmedAt,
        'last_login_at': lastLoginAt,
        'current_team_id': currentTeamId,
        'profile_photo_path': profilePhotoPath,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'status': status,
        'devices': devices.map((device) => device.toJson()).toList(),
      };

  factory User.fromJson(String data) {
    return User.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'role': role,
      'email_verified_at': emailVerifiedAt?.toString(),
      'two_factor_secret': twoFactorSecret,
      'two_factor_recovery_codes': twoFactorRecoveryCodes,
      'two_factor_confirmed_at': twoFactorConfirmedAt?.toString(),
      'last_login_at': lastLoginAt?.toString(),
      'current_team_id': currentTeamId,
      'profile_photo_path': profilePhotoPath,
      'created_at': createdAt?.toString(),
      'updated_at': updatedAt?.toString(),
      'status': status,
      'devices': devices.map((device) => device.toJson()).toList(),
    };
  }

  User copyWith({
    int? id,
    String? name,
    String? email,
    dynamic phone,
    dynamic address,
    String? role,
    dynamic emailVerifiedAt,
    dynamic twoFactorSecret,
    dynamic twoFactorRecoveryCodes,
    dynamic twoFactorConfirmedAt,
    dynamic lastLoginAt,
    dynamic currentTeamId,
    dynamic profilePhotoPath,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? status,
    List<Device>? devices,
  }) {
    return User()
      ..id = id ?? this.id
      ..name = name ?? this.name
      ..email = email ?? this.email
      ..phone = phone ?? this.phone
      ..address = address ?? this.address
      ..role = role ?? this.role
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
      ..status = status ?? this.status
      ..devices = devices ?? List.from(this.devices);
  }

  /// Get formatted creation date
  String get formattedCreatedAt {
    return createdAt?.toLocal().toString().split(' ')[0] ?? 'N/A';
  }

  /// Get formatted last login time
  String get formattedLastLogin {
    if (lastLoginAt == null) return 'Never logged in';
    final lastLogin = lastLoginAt is DateTime
        ? lastLoginAt
        : DateTime.parse(lastLoginAt.toString());
    return 'Last seen ${lastLogin.toLocal().toString().split('.')[0]}';
  }
}
