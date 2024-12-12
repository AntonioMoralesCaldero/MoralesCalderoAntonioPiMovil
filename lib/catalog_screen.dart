import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/vehiculo.dart';
import 'vehicle_detail_screen.dart';
import '../services/auth_service.dart';

class CatalogScreen extends StatefulWidget {
  @override
  _CatalogScreenState createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  late Future<List<Vehiculo>> _vehiculosFuture;
  final AuthService authService = AuthService();

  Future<List<Vehiculo>> fetchVehiculos() async {
    final token = await authService.getToken();

    if (token == null) {
      throw Exception('Debe iniciar sesión para ver el catálogo.');
    }

    final response = await http.get(
      Uri.parse('https://moralescalderoantoniopiapis-production.up.railway.app/api/catalogo'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((vehiculo) => Vehiculo.fromJson(vehiculo)).toList();
    } else if (response.statusCode == 401) {
      throw Exception('Sesión inválida o expirada.');
    } else {
      throw Exception('Error al cargar el catálogo.');
    }
  }

  @override
  void initState() {
    super.initState();
    _vehiculosFuture = fetchVehiculos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Catálogo de Vehículos")),
      body: FutureBuilder<List<Vehiculo>>(
        future: _vehiculosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            final vehiculos = snapshot.data!;
            return ListView.builder(
              itemCount: vehiculos.length,
              itemBuilder: (context, index) {
                final vehiculo = vehiculos[index];
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    leading: Image.network(
                      vehiculo.imagen,
                      width: 80,
                      fit: BoxFit.cover,
                    ),
                    title: Text(vehiculo.modelo),
                    subtitle: Text("Precio: ${vehiculo.precio.toStringAsFixed(2)} €"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VehicleDetailScreen(vehiculo: vehiculo),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
