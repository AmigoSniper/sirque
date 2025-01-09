import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:salescheck/Model/Dasboard.dart';
import 'package:salescheck/Model/chartData.dart';

import '../Model/UserData.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Apidasboard {
  final api = Uri.parse(dotenv.env['API_URL']!);
  final image = Uri.parse(dotenv.env['Image_URL']!);
  int? statusCode;
  String? message;
  UserData? userData;
  Future<UserData> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('userData');
    final jsonData = jsonDecode(data!) as Map<String, dynamic>;
    // Parse JSON ke model UserData
    UserData userData = UserData.fromJson(jsonData);

    return userData;
  }

  Future<Dasboard?> getDasboard(String? periode, int idOutlet) async {
    final uri = Uri.parse('$api/dashboard/$idOutlet/mobile?periode=$periode');
    UserData userData = await _getToken();
    final headers = {
      'Authorization': 'Bearer ${userData.token}', // Token pengguna
      'Content-Type': 'application/json', // Tipe konten untuk JSON
    };

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final result = jsonDecode(response.body);
      final Map<String, dynamic> jsonData = result['data'];

      final Dasboard dasboard = Dasboard.fromJson(jsonData);

      statusCode = response.statusCode;

      return dasboard;
    } else {
      statusCode = response.statusCode;

      return null;
    }
  }

  Future<List<chartData>> getChart(String periode, int idOutlet) async {
    final uriBase = Uri.parse('$api/transaksi/statistik?status');
    String periodeStatus = Uri.encodeComponent(periode.toLowerCase());
    final uri = Uri.parse('$uriBase=$periodeStatus&id_outlet=$idOutlet');
    UserData userData = await _getToken();
    final headers = {
      'Authorization': 'Bearer ${userData.token}', // Token pengguna
      'Content-Type': 'application/json', // Tipe konten untuk JSON
    };

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final result = jsonDecode(response.body);
      final List<dynamic> jsonData = result['data'];

      final List<chartData> chardata = jsonData
          .map((item) => chartData.fromJson(item as Map<String, dynamic>))
          .toList();

      statusCode = response.statusCode;
      return chardata;
    } else {
      statusCode = response.statusCode;

      return [];
    }
  }
}
