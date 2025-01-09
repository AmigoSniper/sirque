import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:salescheck/Model/category.dart';
import 'package:salescheck/Model/outlets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/UserData.dart';

class Api {
  final api = Uri.parse(dotenv.env['API_URL']!);
  int? statusCode;
  String? message;

  Future<void> _saveUserTokenAndData(String jsonString) async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> jsonData = jsonDecode(jsonString);
    final userData = UserData.fromJson(jsonData);

    await prefs.setString('userData', jsonEncode(userData.toJson()));
  }

  Future<void> loginwithEmail(String email, String password) async {
    final Map<String, dynamic> requestData = {
      'email': email,
      'password': password,
    };

    try {
      final url = Uri.parse('$api/auth/login');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestData),
      );

      final responseData = jsonDecode(response.body);

      // Periksa status code
      if (response.statusCode == 200) {
        _saveUserTokenAndData(response.body);
        statusCode = response.statusCode;
        message = responseData['message'];
      } else {
        statusCode = response.statusCode;
        message = responseData['message'];
      }
    } catch (error) {}
  }

  Future<void> loginwithToken(String token) async {
    final Map<String, dynamic> requestData = {'tokenLogin': token};

    try {
      final url = Uri.parse('$api/auth/login-token');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestData),
      );

      final responseData = jsonDecode(response.body);

      // Periksa status code
      if (response.statusCode == 200) {
        _saveUserTokenAndData(response.body);
        statusCode = response.statusCode;
        message = responseData['message'];
      } else {
        statusCode = response.statusCode;
        message = responseData['message'];
      }
    } catch (error) {}
  }

  Future<void> signup(
    String nama,
    String email,
    String password,
    String role,
  ) async {
    final Map<String, dynamic> requestData = {
      "name": nama,
      'email': email,
      'password': password,
      "role": role
    };

    try {
      final url = Uri.parse('$api/auth/register');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestData),
      );

      final responseData = jsonDecode(response.body);

      // Periksa status code
      if (response.statusCode == 201) {
      } else {}
    } catch (error) {}
  }
}
