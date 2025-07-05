// import 'dart:io';

// import 'package:dio/dio.dart';
// import 'package:ta_mobile/models/user.dart';
// import 'package:ta_mobile/services/api_service.dart';
// import 'package:ta_mobile/services/preferences/user_preferences_service.dart';

// class AccountService {
//   /// Ambil profil pengguna saat ini
//   static Future<Map<String, dynamic>> getProfile() async {
//     try {
//       final response = await ApiService().get('/profile');

//       if (response['success'] == true) {
//         final user = User.fromMap(response['data']['user']);
//         await UserPreferencesService().saveUser(user);
//         return {
//           'success': true,
//           'user': user,
//         };
//       } else {
//         return {
//           'success': false,
//           'message': response['message'] ?? 'Failed to load profile',
//         };
//       }
//     } catch (e) {
//       return {
//         'success': false,
//         'message': 'Error: $e',
//       };
//     }
//   }

//   /// Update profil pengguna: nama, email, no HP, alamat
//   static Future<Map<String, dynamic>> updateProfile({
//     String? name,
//     String? email,
//     String? phone,
//     String? address,
//   }) async {
//     try {
//       final Map<String, dynamic> data = {};
//       if (name != null) data['name'] = name;
//       if (email != null) data['email'] = email;
//       if (phone != null) data['phone'] = phone;
//       if (address != null) data['address'] = address;

//       final response = await ApiService().put('/profile', data);

//       if (response['success'] == true) {
//         final user = User.fromMap(response['data']['user']);
//         await UserPreferencesService().saveUser(user);
//         return {
//           'success': true,
//           'message': response['data']['message'] ?? 'Profile updated',
//           'user': user,
//         };
//       } else {
//         return {
//           'success': false,
//           'message': response['message'] ?? 'Update failed',
//         };
//       }
//     } catch (e) {
//       return {
//         'success': false,
//         'message': 'Error: $e',
//       };
//     }
//   }

//   /// Update password pengguna
//   static Future<Map<String, dynamic>> updatePassword({
//     required String currentPassword,
//     required String newPassword,
//     required String newPasswordConfirmation,
//   }) async {
//     try {
//       final response = await ApiService().put('/profile/password', {
//         'current_password': currentPassword,
//         'new_password': newPassword,
//         'new_password_confirmation': newPasswordConfirmation,
//       });

//       if (response['success'] == true) {
//         return {
//           'success': true,
//           'message': response['data']['message'] ?? 'Password updated',
//         };
//       } else {
//         return {
//           'success': false,
//           'message': response['message'] ?? 'Failed to update password',
//         };
//       }
//     } catch (e) {
//       return {
//         'success': false,
//         'message': 'Error: $e',
//       };
//     }
//   }

//   /// Upload foto profil pengguna
//   static Future<Map<String, dynamic>> uploadProfilePhoto(File photoFile) async {
//     try {
//       final formData = FormData.fromMap({
//         'photo': await MultipartFile.fromFile(photoFile.path,
//             filename: photoFile.path.split('/').last),
//       });

//       final dio = Dio(BaseOptions(
//         baseUrl: ApiService().baseUrl,
//         headers: {
//           'Authorization': 'Bearer ${ApiService().getToken()}',
//           'Accept': 'application/json',
//         },
//       ));

//       final response = await dio.post('/profile/photo', data: formData);

//       if (response.statusCode == 200 && response.data['success'] == true) {
//         final user = await UserPreferencesService().getUser();
//         if (user != null) {
//           user.profilePhotoPath = response.data['photo_url'];
//           await UserPreferencesService().saveUser(user);
//         }

//         return {
//           'success': true,
//           'message': response.data['message'] ?? 'Photo updated',
//           'photo_url': response.data['photo_url'],
//         };
//       } else {
//         return {
//           'success': false,
//           'message': response.data['message'] ?? 'Failed to update photo',
//         };
//       }
//     } catch (e) {
//       return {
//         'success': false,
//         'message': 'Error uploading photo: $e',
//       };
//     }
//   }

//   /// Hapus foto profil pengguna
//   static Future<Map<String, dynamic>> deleteProfilePhoto() async {
//     try {
//       final response = await ApiService().delete('/profile/photo');

//       if (response['success'] == true) {
//         final user = await UserPreferencesService().getUser();
//         if (user != null) {
//           user.profilePhotoPath = null;
//           await UserPreferencesService().saveUser(user);
//         }

//         return {
//           'success': true,
//           'message': response['message'] ?? 'Photo removed',
//         };
//       } else {
//         return {
//           'success': false,
//           'message': response['message'] ?? 'Failed to remove photo',
//         };
//       }
//     } catch (e) {
//       return {
//         'success': false,
//         'message': 'Error: $e',
//       };
//     }
//   }
  
// }

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:ta_mobile/models/user.dart';
import 'package:ta_mobile/services/api_service.dart';
import 'package:ta_mobile/services/preferences/user_preferences_service.dart';

class AccountService {
  /// Ambil profil pengguna saat ini
  static Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await ApiService().get('/profile');

      if (response['success'] == true) {
        final user = User.fromMap(response['data']['user']);
        await UserPreferencesService().saveUser(user);
        return {
          'success': true,
          'user': user,
        };
      } else {
        return {
          'success': false,
          'message': response['message'] ?? 'Failed to load profile',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }

  /// Update profil pengguna: nama, email, no HP, alamat
  static Future<Map<String, dynamic>> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? address,
  }) async {
    try {
      final Map<String, dynamic> data = {};
      if (name != null) data['name'] = name;
      if (email != null) data['email'] = email;
      if (phone != null) data['phone'] = phone;
      if (address != null) data['address'] = address;

      final response = await ApiService().put('/profile', data);

      if (response['success'] == true) {
        final user = User.fromMap(response['data']['user']);
        await UserPreferencesService().saveUser(user);
        return {
          'success': true,
          'message': response['data']['message'] ?? 'Profile updated',
          'user': user,
        };
      } else {
        return {
          'success': false,
          'message': response['message'] ?? 'Update failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }

  /// Update password pengguna
  static Future<Map<String, dynamic>> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    try {
      final response = await ApiService().put('/profile/password', {
        'current_password': currentPassword,
        'new_password': newPassword,
        'new_password_confirmation': newPasswordConfirmation,
      });

      if (response['success'] == true) {
        return {
          'success': true,
          'message': response['data']['message'] ?? 'Password updated',
        };
      } else {
        return {
          'success': false,
          'message': response['message'] ?? 'Failed to update password',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }

  /// Upload foto profil pengguna
  static Future<Map<String, dynamic>> uploadProfilePhoto(File photoFile) async {
    try {
      final formData = FormData.fromMap({
        'photo': await MultipartFile.fromFile(
          photoFile.path,
          filename: photoFile.path.split('/').last,
        ),
      });

      final dio = Dio(BaseOptions(
        baseUrl: ApiService().baseUrl,
        headers: {
          'Authorization': 'Bearer ${ApiService().getToken()}',
          'Accept': 'application/json',
        },
      ));

      final response = await dio.post('/profile/photo', data: formData);

      if (response.statusCode == 200 && response.data['success'] == true) {
        final user = await UserPreferencesService().getUser();
        if (user != null) {
          user.profilePhotoPath = response.data['photo_url'];
          await UserPreferencesService().saveUser(user);
        }

        return {
          'success': true,
          'message': response.data['message'] ?? 'Photo updated',
          'photo_url': response.data['photo_url'],
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Failed to update photo',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error uploading photo: $e',
      };
    }
  }

  /// Hapus foto profil pengguna
  static Future<Map<String, dynamic>> deleteProfilePhoto() async {
    try {
      final response = await ApiService().delete('/profile/photo');

      if (response['success'] == true) {
        final user = await UserPreferencesService().getUser();
        if (user != null) {
          user.profilePhotoPath = null;
          await UserPreferencesService().saveUser(user);
        }

        return {
          'success': true,
          'message': response['message'] ?? 'Photo removed',
        };
      } else {
        return {
          'success': false,
          'message': response['message'] ?? 'Failed to remove photo',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }
}
