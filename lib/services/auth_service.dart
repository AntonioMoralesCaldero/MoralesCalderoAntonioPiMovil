import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final String baseUrl = "https://moralescalderoantoniopiapis-production.up.railway.app/api/auth";
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      body: {'username': username, 'password': password},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      await secureStorage.write(key: "jwtToken", value: data['token']);
      return data;
    } else {
      throw Exception('Error: ${response.body}');
    }
  }

  Future<String> register(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(userData),
    );

    if (response.statusCode == 201) {
      return 'Usuario registrado con éxito';
    } else {
      throw Exception('Error: ${response.body}');
    }
  }

  Future<void> logout() async {
    await secureStorage.delete(key: "jwtToken");
  }

  Future<String?> getToken() async {
    return await secureStorage.read(key: "jwtToken");
  }
}
