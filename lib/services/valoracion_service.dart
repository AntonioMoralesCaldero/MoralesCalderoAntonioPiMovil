import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ValoracionService {
  final String baseUrl = 'https://moralescalderoantoniopiapis-production.up.railway.app/api/taller';
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  Future<void> guardarValoracion(int citaId, int puntuacion, String comentario) async {
    final String? token = await secureStorage.read(key: 'jwtToken');
    if (token == null) {
      throw Exception('Token no encontrado. Por favor, inicia sesión.');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/citas/$citaId/valorar'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'puntuacion': puntuacion,
        'comentario': comentario,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Error: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> obtenerValoracion(int citaId) async {
    final String? token = await secureStorage.read(key: 'jwtToken');
    if (token == null) {
      throw Exception('Token no encontrado. Por favor, inicia sesión.');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/citas/$citaId/ver-valoracion'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Error al obtener la valoración: ${response.body}');
    }

    return jsonDecode(response.body);
  }

  Future<void> editarValoracion(int citaId, int puntuacion, String comentario) async {
    final String? token = await secureStorage.read(key: 'jwtToken');
    if (token == null) {
      throw Exception('Token no encontrado. Por favor, inicia sesión.');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/citas/$citaId/guardar-valoracion'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'puntuacion': puntuacion,
        'comentario': comentario,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar la valoración: ${response.body}');
    }
  }
}