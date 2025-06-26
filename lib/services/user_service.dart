import 'package:ta_mobile/models/user.dart';
import 'package:ta_mobile/services/api_service.dart';

class UserService {
  final ApiService _api = ApiService();

  Future<User> updateProfile({
    required String userId,
    required String name,
    required String email,
    String? phone,
    String? address,
  }) async {
    final response = await _api.put(
      '/profile',
      {
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
      },
    );

    if (response['success']) {
      return User.fromJson(response['data']['user']);
    } else {
      throw Exception(response['message'] ?? 'Failed to update profile');
    }
  }

  Future<String?> uploadProfilePhoto(String filePath) async {
    // Implement multipart upload if needed
    return null;
  }
}
