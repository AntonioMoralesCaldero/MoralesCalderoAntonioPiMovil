import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class VentaService {
  final String baseUrl = "https://moralescalderoantoniopiapis-production.up.railway.app/api/venta";
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  Future<List<dynamic>> obtenerCochesDelUsuario() async {
    final token = await secureStorage.read(key: "jwtToken");
    if (token == null) {
      throw Exception("No hay token disponible");
    }

    final response = await http.get(
      Uri.parse('$baseUrl/mis-coches'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Error al obtener los coches: ${response.body}");
    }
  }

  Future<String> agregarVehiculo(Map<String, String> datosVehiculo, String imagePath) async {
    final token = await secureStorage.read(key: "jwtToken");
    if (token == null) {
      throw Exception("No hay token disponible");
    }

    final uri = Uri.parse('$baseUrl/vender-tu-coche/agregar');
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['datosVehiculo'] = json.encode(datosVehiculo)
      ..files.add(await http.MultipartFile.fromPath('imagenFile', imagePath));

    final response = await request.send();
    if (response.statusCode == 200) {
      return "Vehículo agregado con éxito";
    } else {
      throw Exception("Error al agregar el vehículo");
    }
  }
}
