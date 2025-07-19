import 'dart:developer' show log;

import 'package:ta_mobile/models/user.dart';
import 'package:ta_mobile/services/api_service.dart';
import 'package:ta_mobile/services/preferences/user_preferences_service.dart';

class EmailVerificationService {
  // Send verification code to user's email
  static Future<Map<String, dynamic>> sendVerificationCode() async {
    try {
      final response = await ApiService().post(
        '/send-verification',
        {},
        useToken: true,
      );

      log("Send verification response: $response");

      if (response['success'] == true) {
        return {
          "success": true,
          "message": response['message'] ?? "Verification code sent",
          "expires_at": response['data']['expires_at'],
        };
      } else {
        return {
          "success": false,
          "message": response['message'] ?? "Failed to send verification code",
        };
      }
    } catch (e) {
      log("Error sending verification code: $e");
      return {
        "success": false,
        "message": "Error sending verification code: $e",
      };
    }
  }

  // Verify email with the received code
  static Future<Map<String, dynamic>> verifyEmail(String code) async {
    try {
      final response = await ApiService().post(
        '/verify-email',
        {"code": code,
        "email":User().email
        },
        useToken: true,
      );

      log("Verify email response: $response");

      if (response['success'] == true) {
        // Update local user data
        final currentUser = await UserPreferencesService().getUser();
        if (currentUser != null) {
          final updatedUser = currentUser.copyWith(
            emailVerifiedAt: DateTime.now(),
          );
          await UserPreferencesService().saveUser(updatedUser);
        }

        return {
          "success": true,
          "message": response['message'] ?? "Email verified successfully",
          "user": currentUser,
        };
      } else {
        return {
          "success": false,
          "message": response['message'] ?? "Email verification failed",
        };
      }
    } catch (e) {
      log("Error verifying email: $e");
      return {
        "success": false,
        "message": "Error verifying email: $e",
      };
    }
  }

  // Check verification status
  static Future<Map<String, dynamic>> checkVerificationStatus() async {
    try {
      final response = await ApiService().get(
        '/check-verification',
        useToken: true,
      );

      log("Verification status response: $response");

      if (response['success'] == true) {
        return {
          "success": true,
          "is_verified": response['data']['is_verified'] ?? false,
        };
      } else {
        return {
          "success": false,
          "message": response['message'] ?? "Failed to check verification status",
        };
      }
    } catch (e) {
      log("Error checking verification status: $e");
      return {
        "success": false,
        "message": "Error checking verification status: $e",
      };
    }
  }

  // Resend verification code
  static Future<Map<String, dynamic>> resendVerificationCode() async {
    try {
      final response = await ApiService().post(
        '/send-verification',
        {
          "email":User().email
        },
        useToken: true,
      );

      log("Resend verification response: $response");

      if (response['success'] == true) {
        return {
          "success": true,
          "message": response['message'] ?? "Verification code resent",
          "expires_at": response['data']['expires_at'],
        };
      } else {
        return {
          "success": false,
          "message": response['message'] ?? "Failed to resend verification code",
        };
      }
    } catch (e) {
      log("Error resending verification code: $e");
      return {
        "success": false,
        "message": "Error resending verification code: $e",
      };
    }
  }
}