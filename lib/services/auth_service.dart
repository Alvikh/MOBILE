import 'package:ta_mobile/models/user.dart';
import 'package:ta_mobile/services/api_service.dart';
import 'package:ta_mobile/services/preferences/user_preferences_service.dart';

class AuthService {
  static Future<Map<String, dynamic>> signUp(
      String email, String password) async {
    try {
      final response = await ApiService().post(
        '/register',
        {
          "email": email,
          "password": password,
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

      if (response['success'] == true) {
        print(
            "successs 1 debug user : ${response['user']}, token: ${response['token']} , refresh_token: ${response['refresh_token']}, success: ${response['success']} ");
        await _saveAuthData(
          token: response['data']['token'],
          refreshToken: response['data']['refresh_token'],
          userData: response['data']['user'],
        );
        print("successs 2 debug");
        return {
          "success": true,
          "message": "Login successful",
          "user": User.fromMap(response['data']['user']),
        };
      } else {
        return {
          "success": false,
          "message": response['data']['message'] ?? "Login failed",
        };
      }
    } catch (e) {
      print("error debug: $e");
      return {"success": false, "message": "coooook: $e"};
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

      // 2. Clear local data regardless of API response
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
