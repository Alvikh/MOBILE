import 'dart:convert';

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
    return 'User(id: $id, name: $name, email: $email, phone: $phone, address: $address, role: $role, emailVerifiedAt: $emailVerifiedAt, twoFactorSecret: $twoFactorSecret, twoFactorRecoveryCodes: $twoFactorRecoveryCodes, twoFactorConfirmedAt: $twoFactorConfirmedAt, lastLoginAt: $lastLoginAt, currentTeamId: $currentTeamId, profilePhotoPath: $profilePhotoPath, createdAt: $createdAt, updatedAt: $updatedAt, status: $status)';
  }

  factory User.fromMap(Map<String, dynamic> data) {
    User().init(data);
    return User();
  }
  void updateFromJson(Map<String, dynamic> json) {
    if (json.containsKey('id')) id = json['id'] as int?;
    if (json.containsKey('name')) name = json['name'] as String?;
    if (json.containsKey('email')) email = json['email'] as String?;
    if (json.containsKey('phone')) phone = json['phone'] as String?;
    if (json.containsKey('address')) address = json['address'] as String?;
    if (json.containsKey('role')) role = json['role'] as String?;

    if (json.containsKey('email_verified_at')) {
      emailVerifiedAt = json['email_verified_at'] != null
          ? DateTime.tryParse(json['email_verified_at'] as String)
          : null;
    }
    if (json.containsKey('two_factor_secret'))
      twoFactorSecret = json['two_factor_secret'] as String?;
    if (json.containsKey('two_factor_recovery_codes'))
      twoFactorRecoveryCodes = json['two_factor_recovery_codes'] as String?;
    if (json.containsKey('two_factor_confirmed_at')) {
      twoFactorConfirmedAt = json['two_factor_confirmed_at'] != null
          ? DateTime.tryParse(json['two_factor_confirmed_at'] as String)
          : null;
    }
    if (json.containsKey('last_login_at')) {
      lastLoginAt = json['last_login_at'] != null
          ? DateTime.tryParse(json['last_login_at'] as String)
          : null;
    }
    if (json.containsKey('current_team_id'))
      currentTeamId = json['current_team_id'] as int?;
    if (json.containsKey('profile_photo_path'))
      profilePhotoPath = json['profile_photo_path'] as String?;

    if (json.containsKey('created_at')) {
      createdAt = json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null;
    }
    if (json.containsKey('updated_at')) {
      updatedAt = json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null;
    }
    if (json.containsKey('status')) status = json['status'] as String?;
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
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'two_factor_secret': twoFactorSecret,
      'two_factor_recovery_codes': twoFactorRecoveryCodes,
      'two_factor_confirmed_at': twoFactorConfirmedAt?.toIso8601String(),
      'last_login_at': lastLoginAt?.toIso8601String(),
      'current_team_id': currentTeamId,
      'profile_photo_path': profilePhotoPath,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'status': status,
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
      ..status = status ?? this.status;
  }

  /// Get formatted creation date
  String get formattedCreatedAt {
    return createdAt?.toLocal().toString().split(' ')[0] ?? 'N/A';
  }

  /// Get formatted last login time
  String get formattedLastLogin {
    if (lastLoginAt == null) return 'Never logged in';
    final lastLogin = DateTime.parse(lastLoginAt.toString());
    return 'Last seen ${lastLogin.toLocal().toString().split('.')[0]}';
  }
}
