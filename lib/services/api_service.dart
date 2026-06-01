import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class ApiService {
  static const String baseUrl = "https://crime-alert.onrender.com/api";

  // 🔐 LOGIN
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    return jsonDecode(response.body);
  }

  // 👤 REGISTER
  static Future<Map<String, dynamic>> register(
      String name, String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
      }),
    );

    return jsonDecode(response.body);
  }


  static Future<bool> createReport({
    required String title,
    required String description,
    required String nearPoliceStation,
    required String address,
    required String latitude,
    required String longitude,
    File? image,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    var request = http.MultipartRequest(
      'POST',
      Uri.parse("$baseUrl/reports"),
    );

    request.headers['Authorization'] = "Bearer $token";

    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['nearPoliceStation'] = nearPoliceStation;
    request.fields['address'] = address;
    request.fields['latitude'] = latitude;
    request.fields['longitude'] = longitude;

    if (image != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          image.path,
        ),
      );
    }

    var response = await request.send();

    return response.statusCode == 201;
  }

  static Future<List<dynamic>> getMyReports() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    final response = await http.get(
      Uri.parse("$baseUrl/reports/my"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    return jsonDecode(response.body);
  }


  static Future<bool> deleteReport(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    final response = await http.delete(
      Uri.parse("$baseUrl/reports/$id"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    return response.statusCode == 200;
  }
}