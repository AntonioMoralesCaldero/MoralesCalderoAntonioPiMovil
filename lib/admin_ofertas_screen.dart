import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AdminOfertasScreen extends StatefulWidget {
  @override
  _AdminOfertasScreenState createState() => _AdminOfertasScreenState();
}

class _AdminOfertasScreenState extends State<AdminOfertasScreen> {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final String baseUrl =
      "https://moralescalderoantoniopiapis-production.up.railway.app/api/admin/ofertas";

  List<dynamic> _ofertasPendientes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarOfertasPendientes();
  }

  Future<void> _cargarOfertasPendientes() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final token = await _storage.read(key: "jwtToken");
      if (token == null) {
        throw Exception("No se encontró el token de autenticación.");
      }

      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        setState(() {
          _ofertasPendientes = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        throw Exception("Error al cargar ofertas: ${response.body}");
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  Future<void> _aceptarOferta(int ofertaId) async {
    await _gestionarOferta(ofertaId, "aceptar");
  }

  Future<void> _rechazarOferta(int ofertaId) async {
    await _gestionarOferta(ofertaId, "rechazar");
  }

  Future<void> _gestionarOferta(int ofertaId, String accion) async {
    try {
      final token = await _storage.read(key: "jwtToken");
      if (token == null) {
        throw Exception("No se encontró el token de autenticación.");
      }

      final url = Uri.parse("$baseUrl/$ofertaId/$accion");
      final response = await http.post(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Oferta $accion exitosa.")),
        );
        _cargarOfertasPendientes();
      } else {
        throw Exception("Error al $accion la oferta: ${response.body}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ofertas Pendientes"),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _ofertasPendientes.isEmpty
              ? Center(child: Text("No hay ofertas pendientes."))
              : ListView.builder(
                  itemCount: _ofertasPendientes.length,
                  itemBuilder: (context, index) {
                    final oferta = _ofertasPendientes[index];
                    return Card(
                      margin: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            leading: oferta['imagen'] != null
                                ? Image.network(
                                    oferta['imagen'],
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  )
                                : Icon(Icons.directions_car),
                            title: Text("Modelo: ${oferta['modelo']}"),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Color: ${oferta['color']}"),
                                Text("Precio: €${oferta['precio']}"),
                                Text("Potencia: ${oferta['potencia']} HP"),
                                Text("Matrícula: ${oferta['matricula']}"),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: Icon(Icons.check, color: Colors.green),
                                onPressed: () =>
                                    _aceptarOferta(oferta['id']),
                              ),
                              IconButton(
                                icon: Icon(Icons.close, color: Colors.red),
                                onPressed: () =>
                                    _rechazarOferta(oferta['id']),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
