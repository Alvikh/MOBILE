import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
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

  /// Save complete user data
  Future<bool> saveUser(User user) async {
    await _ensureInitialized();
    try {
      final userJson = jsonEncode(user.toJson());
      final tokenSaved = await _prefs.setString(_keyUserData, userJson);
      final loginStatusSaved = await _prefs.setBool(_keyIsLoggedIn, true);

      // Debugging: Cetak nilai yang disimpan
      print('User saved: $userJson');
      print('Login status: true ${_prefs.getBool(_keyIsLoggedIn)}');

      return tokenSaved && loginStatusSaved;
    } catch (e) {
      print('Error saving user: $e');
      return false;
    }
  }

  Future<bool> isLoggedIn() async {
    await _ensureInitialized();
    // Periksa kedua kondisi: status login DAN token tersedia
    final hasLoginFlag = _prefs.getBool(_keyIsLoggedIn) ?? false;
    final hasUserData = _prefs.getString(_keyUserData) != null;
    final hasToken = _prefs.getString(_keyAuthToken) != null;

    print(
        'Login check - Flag: $hasLoginFlag, User: $hasUserData, Token: $hasToken');

    return hasLoginFlag && hasUserData && hasToken;
  }

  /// Save authentication tokens
  Future<void> saveTokens(
      {required String authToken, String? refreshToken}) async {
    await _ensureInitialized();
    await _prefs.setString(_keyAuthToken, authToken);
    if (refreshToken != null) {
      await _prefs.setString(_keyRefreshToken, refreshToken);
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

  /// Clear all user data (logout)
  Future<void> clearUserData() async {
    await _ensureInitialized();
    await _prefs.remove(_keyUserData);
    await _prefs.remove(_keyAuthToken);
    await _prefs.remove(_keyRefreshToken);
    await _prefs.setBool(_keyIsLoggedIn, false);

    // Also clear the singleton User instance
    User().clear();
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
}
