import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moralescalderoantoniopimovil/models/Cita.dart';

class CitaService {
  final String apiUrl = 'https://moralescalderoantoniopiapis-production.up.railway.app/api/taller/citas';
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  Future<String> crearCita(CitaModel cita) async {
    final token = await secureStorage.read(key: 'jwtToken');
    if (token == null) {
      throw Exception('Token no encontrado');
    }

    final response = await http.post(
      Uri.parse('$apiUrl/crear'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(cita.toJson()),
    );

    if (response.statusCode == 200) {
      return '¡Cita creada con éxito!';
    } else {
      throw Exception('Error al crear la cita: ${response.body}');
    }
  }

  Future<List<CitaModel>> obtenerCitas() async {
    final token = await secureStorage.read(key: 'jwtToken');
    if (token == null) {
      throw Exception('Token no encontrado');
    }

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> citasJson = jsonDecode(response.body);
      return citasJson.map((json) => CitaModel.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener las citas: ${response.body}');
    }
  }
}
