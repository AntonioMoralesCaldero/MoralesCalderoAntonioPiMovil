import 'package:flutter/material.dart';
import 'package:moralescalderoantoniopimovil/services/venta_service.dart';

class MisCochesScreen extends StatefulWidget {
  @override
  _MisCochesScreenState createState() => _MisCochesScreenState();
}

class _MisCochesScreenState extends State<MisCochesScreen> {
  final VentaService ventaService = VentaService();
  late Future<List<dynamic>> _coches;

  @override
  void initState() {
    super.initState();
    _coches = ventaService.obtenerCochesDelUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mis Coches")),
      body: FutureBuilder<List<dynamic>>(
        future: _coches,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No tienes coches registrados."));
          } else {
            final coches = snapshot.data!;
            return ListView.builder(
              itemCount: coches.length,
              itemBuilder: (context, index) {
                final coche = coches[index];
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    leading: coche['imagen'] != null && coche['imagen'].isNotEmpty
                        ? Image.network(
                            coche['imagen'],
                            width: 80,
                            fit: BoxFit.cover,
                          )
                        : Icon(Icons.directions_car, size: 50),
                    title: Text(coche['modelo']),
                    subtitle: Text(coche['matricula']),
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
