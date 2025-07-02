import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:ta_mobile/models/device.dart';
import 'package:ta_mobile/models/user.dart';

class UserPreferencesService {
  static const _keyUserData = 'user_data';
  static const _keyAuthToken = 'auth_token';
  static const _keyRefreshToken = 'refresh_token';
  static const _keyIsLoggedIn = 'is_logged_in';

  // Singleton instance with lazy initialization
  static final UserPreferencesService _instance =
      UserPreferencesService._internal();
  factory UserPreferencesService() => _instance;
  UserPreferencesService._internal() {
    // Initialize when the instance is created
    _init();
  }

  late SharedPreferences _prefs;
  bool _isInitialized = false;
  final _initializationCompleter = Completer<void>();

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    _isInitialized = true;
    _initializationCompleter.complete();
  }

  /// Ensure preferences are initialized before use
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await _initializationCompleter.future;
    }
  }

  /// Save complete user data with null handling
  Future<bool> saveUser(User user) async {
    await _ensureInitialized();
    try {
      // Convert the user to a map with null values replaced by empty strings
      final userMap = user.toMap().map((key, value) {
        if (value == null) {
          return MapEntry(key, '');
        }
        if (value is List) {
          return MapEntry(
              key, value.map((e) => e is Device ? e.toMap() : e).toList());
        }
        return MapEntry(key, value);
      });

      final userJson = jsonEncode(userMap);
      final tokenSaved = await _prefs.setString(_keyUserData, userJson);
      final loginStatusSaved = await _prefs.setBool(_keyIsLoggedIn, true);

      return tokenSaved && loginStatusSaved;
    } catch (e) {
      print('Error saving user: $e');
      return false;
    }
  }

  Future<bool> isLoggedIn() async {
    await _ensureInitialized();
    final hasLoginFlag = _prefs.getBool(_keyIsLoggedIn) ?? false;
    final hasUserData = _prefs.getString(_keyUserData) != null;
    final hasToken = _prefs.getString(_keyAuthToken) != null;

    print(
        'Login check - Flag: $hasLoginFlag, User: $hasUserData, Token: $hasToken');

    return hasLoginFlag && hasUserData && hasToken;
  }

  /// Save authentication tokens
  Future<bool> saveTokens({
    required String authToken,
    required String refreshToken,
  }) async {
    await _ensureInitialized();
    try {
      final authTokenSaved = await _prefs.setString(_keyAuthToken, authToken);
      final refreshTokenSaved = await saveRefreshToken(refreshToken);
      return authTokenSaved && refreshTokenSaved;
    } catch (e) {
      print('Error saving tokens: $e');
      return false;
    }
  }

  /// Get saved user data
  Future<User?> getUser() async {
    await _ensureInitialized();
    final userJson = _prefs.getString(_keyUserData);
    if (userJson == null) return null;

    try {
      return User.fromJson(userJson);
    } catch (e) {
      print('Error parsing user data: $e');
      return null;
    }
  }

  /// Get authentication token
  Future<String?> getAuthToken() async {
    await _ensureInitialized();
    return _prefs.getString(_keyAuthToken);
  }

  /// Get refresh token
  Future<String?> getRefreshToken() async {
    await _ensureInitialized();
    return _prefs.getString(_keyRefreshToken);
  }

  /// Update specific user fields
  Future<bool> updateUserFields(Map<String, dynamic> updates) async {
    await _ensureInitialized();
    try {
      final currentUser = await getUser();
      if (currentUser == null) return false;

      final updatedUser = currentUser.copyWith(
        name: updates['name'],
        email: updates['email'],
        phone: updates['phone'],
        address: updates['address'],
        profilePhotoPath: updates['profile_photo_path'],
      );

      return await saveUser(updatedUser);
    } catch (e) {
      print('Error updating user: $e');
      return false;
    }
  }

  /// Save refresh token
  Future<bool> saveRefreshToken(String refreshToken) async {
    await _ensureInitialized();
    try {
      final result = await _prefs.setString(_keyRefreshToken, refreshToken);
      print('Refresh token saved: $refreshToken');
      return result;
    } catch (e) {
      print('Error saving refresh token: $e');
      return false;
    }
  }

  /// Check if refresh token exists
  Future<bool> hasRefreshToken() async {
    await _ensureInitialized();
    return _prefs.getString(_keyRefreshToken) != null;
  }

  /// Clear all user data
  Future<void> clearUserData() async {
    await _ensureInitialized();
    print('Clearing all user data...');
    await Future.wait([
      _prefs.remove(_keyUserData),
      _prefs.remove(_keyAuthToken),
      _prefs.remove(_keyRefreshToken),
      _prefs.setBool(_keyIsLoggedIn, false),
    ]);
    print('User data cleared');
  }
}
