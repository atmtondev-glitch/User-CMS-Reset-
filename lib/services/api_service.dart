import 'dart:convert';

import 'package:cms_pwd_reset/models/user_cms_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.1.53:2001';
  static const String userCmsEndpoint = '/api/atm/user_cms';
  static const String updateEndpoint = '/api/atm/user_cms_update';

  // ດຶງຂໍ້ມູນຜູ້ໃຊ້ທັງໝົດ
  Future<List<UserCms>> getUsers() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$userCmsEndpoint'),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 30));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        
        if (jsonResponse['responseCode'] == '00') {
          List<dynamic> data = jsonResponse['data'];
          return data.map((user) => UserCms.fromJson(user)).toList();
        } else {
          throw Exception(jsonResponse['message']);
        }
      } else {
        throw Exception('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getUsers: $e');
      throw Exception('Error: $e');
    }
  }

  // ອັບເດດລະຫັດຜ່ານ
  Future<bool> updatePassword(String id, String newPassword) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$updateEndpoint'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'id': id,
          'pass': newPassword,
        }),
      ).timeout(const Duration(seconds: 30));

      print('Update response status: ${response.statusCode}');
      print('Update response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['responseCode'] == '00';
      } else {
        return false;
      }
    } catch (e) {
      print('Update error: $e');
      throw Exception('Update error: $e');
    }
  }
}