import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ValoracionesScreen extends StatefulWidget {
  @override
  _ValoracionesScreenState createState() => _ValoracionesScreenState();
}

class _ValoracionesScreenState extends State<ValoracionesScreen> {
  List<ValoracionModel> valoraciones = [];

  Future<void> cargarValoraciones() async {
    final response = await http.get(
      Uri.parse('https://moralescalderoantoniopiapis-production.up.railway.app/api/admin/valoraciones'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        valoraciones = data.map((item) => ValoracionModel.fromJson(item)).toList();
      });
    } else {
      throw Exception('Error al cargar las valoraciones');
    }
  }

  Future<void> editarComentario(int id, String comentario) async {
    final response = await http.post(
      Uri.parse('https://moralescalderoantoniopiapis-production.up.railway.app/api/admin/valoraciones/$id/editar'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'comentario': comentario,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Comentario actualizado exitosamente')),
      );
      cargarValoraciones();
    } else {
      throw Exception('Error al editar el comentario');
    }
  }

  @override
  void initState() {
    super.initState();
    cargarValoraciones();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Administrar Valoraciones'),
        backgroundColor: Colors.blueAccent,
      ),
      body: valoraciones.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: valoraciones.length,
                itemBuilder: (context, index) {
                  final valoracion = valoraciones[index];
                  TextEditingController comentarioController = TextEditingController(text: valoracion.comentario);

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 8),
                    elevation: 4,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Usuario ID: ${valoracion.usuarioId}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Icon(Icons.star, color: Colors.orange),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Puntuación: ${valoracion.puntuacion}',
                            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Comentario:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 6),
                          Text(
                            valoracion.comentario,
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          SizedBox(height: 12),
                          TextField(
                            controller: comentarioController,
                            decoration: InputDecoration(
                              labelText: 'Editar Comentario',
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blueAccent),
                              ),
                            ),
                            maxLines: 3,
                          ),
                          SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              onPressed: () {
                                String nuevoComentario = comentarioController.text;
                                editarComentario(valoracion.id, nuevoComentario);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              ),
                              child: Text(
                                'Actualizar Comentario',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}

class ValoracionModel {
  final int id;
  final String comentario;
  final int puntuacion;
  final int citaId;
  final int usuarioId;

  ValoracionModel({
    required this.id,
    required this.comentario,
    required this.puntuacion,
    required this.citaId,
    required this.usuarioId,
  });

  factory ValoracionModel.fromJson(Map<String, dynamic> json) {
    return ValoracionModel(
      id: json['id'],
      comentario: json['comentario'],
      puntuacion: json['puntuacion'],
      citaId: json['citaId'],
      usuarioId: json['usuarioId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'comentario': comentario,
      'puntuacion': puntuacion,
      'citaId': citaId,
      'usuarioId': usuarioId,
    };
  }
}
