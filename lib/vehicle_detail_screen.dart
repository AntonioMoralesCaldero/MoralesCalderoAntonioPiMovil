import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/vehiculo.dart';
import '../services/auth_service.dart';

class VehicleDetailScreen extends StatelessWidget {
  final Vehiculo vehiculo;
  final AuthService authService = AuthService();

  VehicleDetailScreen({required this.vehiculo});

  Future<void> realizarCompra(BuildContext context) async {
    final token = await authService.getToken();

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Debe iniciar sesión primero.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final url =
        'https://moralescalderoantoniopiapis-production.up.railway.app/api/compra/${vehiculo.id}';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('¡Compra realizada con éxito!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else if (response.statusCode == 400) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Este coche ya fue vendido.'),
            backgroundColor: Colors.red,
          ),
        );
      } else if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sesión inválida o expirada.'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al procesar la compra.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error de conexión.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Vehículo'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.network(
                  vehiculo.imagen,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20),
              Text(
                vehiculo.modelo,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Color: ${vehiculo.color}',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                'Potencia: ${vehiculo.potencia} CV',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                'Precio: €${vehiculo.precio}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () => realizarCompra(context),
                  child: Text('Comprar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding:
                        EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
