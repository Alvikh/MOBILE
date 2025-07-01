import 'package:ta_mobile/models/user.dart';
import 'package:ta_mobile/services/api_service.dart';
import 'package:ta_mobile/services/preferences/user_preferences_service.dart';

class AuthService {
  // SIGN UP (Register)
  static Future<Map<String, dynamic>> signUp(
      String email, String password) async {
    try {
      final response = await ApiService().post(
        ApiEndpoints.register,
        {
          "email": email,
          "password": password,
        },
        useToken: false,
      );

      if (response['success'] == true) {
        // Save user data if available
        if (response['data']?['user'] != null) {
          await UserPreferencesService()
              .saveUser(User.fromMap(response['data']['user']));
        }

        // Save token if available
        if (response['data']?['token'] != null) {
          await _saveAuthData(
            token: response['data']['token'],
            refreshToken: response['data']?['refresh_token'],
            user: response['data']?['user'],
          );
        }

        return response;
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

  // LOGIN - Fixed version
  static Future<Map<String, dynamic>> signIn(
      String email, String password) async {
    try {
      final response = await ApiService().post(
        ApiEndpoints.login,
        {
          "email": email,
          "password": password,
        },
        useToken: false,
      );

      if (response['success'] == true) {
        // Handle both response structures
        final token = response['token'] ?? response['data']?['token'];
        final userData = response['user'] ?? response['data']?['user'];

        if (token != null) {
          await _saveAuthData(
            token: token,
            refreshToken:
                response['refresh_token'] ?? response['data']?['refresh_token'],
            user: userData,
          );
        }

        return {
          "success": true,
          "message": response['message'] ?? "Login berhasil",
          "token": token,
          "user": UserPreferencesService().getUser(),
        };
      } else {
        return {
          "success": false,
          "message": response['message'] ?? "Login failed",
        };
      }
    } catch (e) {
      return {"success": false, "message": "Error: $e"};
    }
  }

  // Helper method to save authentication data
  static Future<void> _saveAuthData({
    required String token,
    String? refreshToken,
    dynamic user,
  }) async {
    await ApiService().setToken(token);
    await UserPreferencesService().saveTokens(
      authToken: token,
      refreshToken: refreshToken,
    );

    if (user != null) {
      await UserPreferencesService().saveUser(
        user is Map<String, dynamic> ? User.fromMap(user) : user,
      );
    }
  }

  // LOGOUT
  static Future<Map<String, dynamic>> logout() async {
    try {
      final response = await ApiService().post(
        '/logout',
        {},
        useToken: true,
      );

      // Always clear local data
      await _clearAuthData();

      return {
        "success": response['success'] ?? true,
        "message": response['message'] ?? "Logged out successfully",
      };
    } catch (e) {
      await _clearAuthData();
      return {"success": false, "message": "Error: $e"};
    }
  }

  // Helper to clear all auth data
  static Future<void> _clearAuthData() async {
    await ApiService().clearToken();
    await UserPreferencesService().clearUserData();
  }

  // COMPLETE PROFILE
  static Future<Map<String, dynamic>> completeProfile(
      Map<String, dynamic> profileData) async {
    try {
      final response = await ApiService().post(
        ApiEndpoints.completeProfile,
        profileData,
        useToken: true,
      );

      if (response['success'] == true && response['data']?['user'] != null) {
        await UserPreferencesService()
            .updateUserFields(response['data']['user']);
      }

      return response;
    } catch (e) {
      return {"success": false, "message": "Error: $e"};
    }
  }

  // GET USER PROFILE
  static Future<Map<String, dynamic>> getUserProfile() async {
    try {
      // Try to get from cache first
      final cachedUser = await UserPreferencesService().getUser();
      if (cachedUser != null) {
        return {
          "success": true,
          "data": {"user": cachedUser.toJson()},
        };
      }

      // Fallback to API
      final response = await ApiService().get(
        '/user',
        useToken: true,
      );

      if (response['success'] == true && response['data']?['user'] != null) {
        await UserPreferencesService()
            .saveUser(User.fromMap(response['data']['user']));
      }

      return response;
    } catch (e) {
      return {"success": false, "message": "Error: $e"};
    }
  }

  // Check if user is authenticated
  static Future<bool> isAuthenticated() async {
    await ApiService().loadToken();
    final hasToken = ApiService().getToken().isNotEmpty;
    final hasUser = UserPreferencesService().getUser() != null;
    return hasToken && hasUser;
  }

  // Get current user (from cache)
  static Future<User?> getCurrentUser() {
    return UserPreferencesService().getUser();
  }

  // Refresh user data from API
  static Future<void> refreshUserData() async {
    try {
      final response = await ApiService().get(
        '/user',
        useToken: true,
      );
      if (response['success'] == true && response['data']?['user'] != null) {
        await UserPreferencesService()
            .saveUser(User.fromMap(response['data']['user']));
      }
    } catch (e) {
      print('Error refreshing user data: $e');
    }
  }
}
