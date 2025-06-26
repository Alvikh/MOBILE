import 'package:ta_mobile/models/user.dart';
import 'package:ta_mobile/services/api_service.dart';

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
        // Optionally save token if register endpoint returns it
        if (response['data']?['token'] != null) {
          await ApiService().setToken(response['data']['token']);
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

  // LOGIN
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
        // Save the token
        // Based on your previous debug output, the token is at the root, not 'data'
        if (response['data']['token'] != null) {
          await ApiService().setToken(response['data']['token']);
        }

        User? loggedInUser; // Declare a User variable
        print("Response user: ${response['data']['user']}");
        print("Response data: ${response['data']}");
        if (response['data']['user'] != null) {
          User().init(response['data']['user']);
        }

        // You might also want to include the User object in the returned map
        // for the calling function to use.
        return {
          "success": true,
          "message": response['message'] ?? "Login berhasil",
          "token":
              response['token'], // Include token in the return for convenience
          "user": loggedInUser, // Include the parsed User object
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

  // LOGOUT
  static Future<Map<String, dynamic>> logout() async {
    try {
      final response = await ApiService().post(
        '/logout',
        {},
        useToken: true,
      );

      if (response['success'] == true) {
        // Clear the token
        await ApiService().clearToken();
        return response;
      } else {
        return {
          "success": false,
          "message": response['message'] ?? "Logout failed",
        };
      }
    } catch (e) {
      return {"success": false, "message": "Error: $e"};
    }
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

      if (response['success'] == true) {
        return response;
      } else {
        return {
          "success": false,
          "message": response['message'] ?? "Profile completion failed",
        };
      }
    } catch (e) {
      return {"success": false, "message": "Error: $e"};
    }
  }

  // GET USER PROFILE
  static Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final response = await ApiService().get(
        '/user',
        useToken: true,
      );

      if (response['success'] == true) {
        return response;
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

  // Check if user is authenticated
  static Future<bool> isAuthenticated() async {
    await ApiService().loadToken();
    return ApiService().getToken().isNotEmpty;
  }
}
