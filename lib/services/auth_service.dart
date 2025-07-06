import 'dart:developer' show log;

import 'package:ta_mobile/models/user.dart';
import 'package:ta_mobile/services/api_service.dart';
import 'package:ta_mobile/services/preferences/user_preferences_service.dart';

class AuthService {
  static Future<Map<String, dynamic>> signUp(
      String email, String password,String confirmPassword,
) async {
    try {
      final response = await ApiService().post(
        '/register',
        {
          "email": email,
          "password": password,
          "password_confirmation": confirmPassword,
        },
        useToken: false,
      );

      if (response['success'] == true) {
        await _saveAuthData(
          token: response['token'],
          refreshToken: response['refresh_token'],
          userData: response['user'],
        );

        return {
          "success": true,
          "message": "Registration successful",
          "user": User.fromMap(response['user']),
        };
      } else {
        return {
          "success": false,
          "message": response['message'] ?? "Registration failed",
        };
      }
    } catch (e) {
      return {"success": false, "message": "Error: $e"};
    }
  }

  // LOGIN
  static Future<Map<String, dynamic>> signIn(
      String email, String password) async {
    try {
      final response = await ApiService().post(
        '/login',
        {
          "email": email,
          "password": password,
        },
        useToken: false,
      );

      // Debug print to see the actual response structure
      log("Full response: $response");

      if (response['success'] == true) {
        // Add null checks for nested data
        final responseData = response['data'] ?? {};
        final token = responseData['token'];
        final refreshToken = responseData['refresh_token'];
        final userData = responseData['user'];

        if (token == null || refreshToken == null || userData == null) {
          return {
            "success": false,
            "message": "Invalid response data structure"
          };
        }

        await _saveAuthData(
          token: token,
          refreshToken: refreshToken,
          userData: userData,
        );

        return {
          "success": true,
          "message": "Login successful",
          "user": User.fromMap(userData),
        };
      } else {
        // Handle error response with null checks
        log("Login failed with response: $response");
        log(ApiEndpoints.baseUrl + '/login');
        final errorMessage =
            (response['data'] ?? {})['message'] ?? "Login failed";
        return {
          "success": false,
          "message": errorMessage,
        };
      }
    } catch (e) {
      log("Error during sign in: $e");
      return {
        "success": false,
        "message": "An error occurred during login. Please try again."
      };
    }
  }

  // COMPLETE PROFILE
  static Future<Map<String, dynamic>> completeProfile({
    required String name,
    required String phone,
    required String address,
  }) async {
    try {
      final response = await ApiService().post(
        '/complete-profile',
        {
          "name": name,
          "phone": phone,
          "address": address,
        },
        useToken: true,
      );

      if (response['success'] == true) {
        await UserPreferencesService().saveUser(User.fromMap(response['user']));
        return {
          "success": true,
          "message": "Profile completed",
          "user": User.fromMap(response['user']),
        };
      } else {
        return {
          "success": false,
          "message": response['message'] ?? "Failed to complete profile",
        };
      }
    } catch (e) {
      return {"success": false, "message": "Error: $e"};
    }
  }

  // GET USER PROFILE
  static Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final response = await ApiService().post(
        '/user',
        {'user_id': User().id},
        useToken: true,
      );

      if (response['success'] == true) {
        final user = User.fromMap(response['user']);
        await UserPreferencesService().saveUser(user);
        return {
          "success": true,
          "user": user,
        };
      } else {
        return {
          "success": false,
          "message": response['message'] ?? "Failed to get user profile",
        };
      }
    } catch (e) {
      return {"success": false, "message": "Error: $e"};
    }
  }

  // REFRESH TOKEN
  static Future<Map<String, dynamic>> refreshToken() async {
    try {
      final refreshToken = await UserPreferencesService().getRefreshToken();
      if (refreshToken == null) {
        await _clearAuthData();
        return {
          "success": false,
          "message": "No refresh token available",
          "shouldLogout": true,
        };
      }

      final response = await ApiService().post(
        '/refresh',
        {"refresh_token": refreshToken},
        useToken: false,
      );

      if (response['success'] == true) {
        await _saveAuthData(
          token: response['token'],
          refreshToken: response['refresh_token']?.toString(),
          userData: response['user'] ??
              (await UserPreferencesService().getUser())?.toMap(),
        );

        return {
          "success": true,
          "message": "Token refreshed",
        };
      } else {
        await _clearAuthData();
        return {
          "success": false,
          "message": response['message'] ?? "Failed to refresh token",
          "shouldLogout": true,
        };
      }
    } catch (e) {
      await _clearAuthData();
      return {
        "success": false,
        "message": "Error: $e",
        "shouldLogout": true,
      };
    }
  }

  static Future<Map<String, dynamic>> logout() async {
    try {
      final response = await ApiService().post(
        '/logout',
        {},
        useToken: true,
      );

      await _clearAuthData();

      // 3. Return appropriate response
      if (response['success'] == true) {
        return {"success": true, "message": "Logged out successfully"};
      } else {
        return {
          "success": false,
          "message": response['message'] ?? "Logout failed"
        };
      }
    } catch (e) {
      // Even if API call fails, clear local data
      await _clearAuthData();
      return {"success": false, "message": "Error during logout: $e"};
    }
  }

  static Future<void> _clearAuthData() async {
    await ApiService().clearToken();
    await UserPreferencesService().clearUserData();
  }

  // Helper methods
  static Future<void> _saveAuthData({
    required String token,
    String? refreshToken,
    required dynamic userData,
  }) async {
    try {
      // 1. Handle berbagai tipe input userData
      late User user;

      if (userData is User) {
        user = userData;
      } else if (userData is Map<String, dynamic>) {
        // Pastikan devices adalah List
        if (userData['devices'] is! List) {
          userData['devices'] = [];
        }
        user = User.fromMap(userData);
      } else {
        throw Exception('Tipe data user tidak valid');
      }

      // 2. Simpan token
      await ApiService().setToken(token);

      // 3. Simpan refresh token jika ada
      if (refreshToken != null && refreshToken.isNotEmpty) {
        await UserPreferencesService().saveRefreshToken(refreshToken);
      }

      // 4. Simpan data user
      await UserPreferencesService().saveUser(user);
    } catch (e, stackTrace) {
      print('Error dalam _saveAuthData: $e\n$stackTrace');
      rethrow;
    }
  }

  // Check authentication status
  static Future<bool> isAuthenticated() async {
    final token = await ApiService().getToken();
    return token.isNotEmpty;
  }

  // Get current user
  static Future<User?> getCurrentUser() async {
    return await UserPreferencesService().getUser();
  }
}
