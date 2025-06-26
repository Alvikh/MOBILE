import 'dart:convert';

import 'package:http/http.dart' as http;

class AccountService {
  static const String baseUrl = "http://10.0.2.2/powersmartiq_api";

  static Future<Map<String, dynamic>> saveAccountInfo({
    required String name,
    required String phone,
    required String email,
    required String address,
  }) async {
    try {
      final url = Uri.parse("$baseUrl/save_account_info.php");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "phone": phone,
          "email": email,
          "address": address,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          "success": false,
          "message": "Server error: ${response.statusCode}"
        };
      }
    } catch (e) {
      return {"success": false, "message": "Error: $e"};
    }
  }
}
