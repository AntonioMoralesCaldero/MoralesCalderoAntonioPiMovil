import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

class AdminCitasScreen extends StatefulWidget {
  @override
  _AdminCitasScreenState createState() => _AdminCitasScreenState();
}

class _AdminCitasScreenState extends State<AdminCitasScreen> {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final String baseUrl =
      "https://moralescalderoantoniopiapis-production.up.railway.app/api/admin/citas";
  final String vehiculosUrl =
      "https://moralescalderoantoniopiapis-production.up.railway.app/api/catalogo";

  List<dynamic> _citas = [];
  List<dynamic> _vehiculos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarCitas();
    _cargarVehiculos();
  }

  Future<void> _cargarCitas() async {
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
          _citas = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        throw Exception("Error al cargar citas: ${response.body}");
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

  Future<void> _cargarVehiculos() async {
    try {
      final token = await _storage.read(key: "jwtToken");
      if (token == null) {
        throw Exception("No se encontró el token de autenticación.");
      }

      final response = await http.get(
        Uri.parse(vehiculosUrl),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        setState(() {
          _vehiculos = json.decode(response.body);
        });
      } else {
        throw Exception("Error al cargar vehículos: ${response.body}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  Future<void> _cancelarCita(int citaId) async {
    try {
      final token = await _storage.read(key: "jwtToken");
      if (token == null) {
        throw Exception("No se encontró el token de autenticación.");
      }

      final response = await http.post(
        Uri.parse("$baseUrl/$citaId/cancelar"),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Cita cancelada exitosamente.")),
        );
        _cargarCitas();
      } else {
        throw Exception("Error al cancelar la cita: ${response.body}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  Future<void> _actualizarCita(int citaId, Map<String, dynamic> datos) async {
    try {
      final token = await _storage.read(key: "jwtToken");
      if (token == null) {
        throw Exception("No se encontró el token de autenticación.");
      }

      final response = await http.post(
        Uri.parse("$baseUrl/$citaId/actualizar"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(datos),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Cita actualizada exitosamente.")),
        );
        _cargarCitas();
      } else {
        throw Exception("Error al actualizar la cita: ${response.body}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  void _mostrarDialogoActualizar(BuildContext context, dynamic cita) {
    final TextEditingController diagnosticoController =
        TextEditingController(text: cita['diagnostico']);
    String estado = cita['estado'];
    DateTime? fechaCita = cita['fechaCita'] != null
        ? DateTime.parse(cita['fechaCita'])
        : null;
    DateTime? fechaFinalizacion = cita['fechaReparacionFinalizada'] != null
        ? DateTime.parse(cita['fechaReparacionFinalizada'])
        : null;
    int? vehiculoOcasionId = cita['vehiculoOcasionId'];

    Future<void> _seleccionarFecha(BuildContext context, bool esCita) async {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );

      if (pickedDate != null) {
        final TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );

        if (pickedTime != null) {
          final DateTime fullDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          setState(() {
            if (esCita) {
              fechaCita = fullDate;
            } else {
              fechaFinalizacion = fullDate;
            }
          });
        }
      }
    }

    void _seleccionarVehiculo() async {
      final vehiculoSeleccionado = await showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Seleccionar Vehículo de Ocasion"),
            content: SingleChildScrollView(
              child: Column(
                children: _vehiculos.map<Widget>((vehiculo) {
                  return ListTile(
                    title: Text(vehiculo['modelo']),
                    onTap: () {
                      Navigator.pop(context, vehiculo['id']);
                    },
                  );
                }).toList(),
              ),
            ),
          );
        },
      );

      if (vehiculoSeleccionado != null) {
        setState(() {
          vehiculoOcasionId = vehiculoSeleccionado;
        });
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Actualizar Cita"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: diagnosticoController,
                  decoration: InputDecoration(labelText: "Diagnóstico"),
                ),
                DropdownButtonFormField<String>(
                  value: estado,
                  items: [
                    DropdownMenuItem(value: "pendiente", child: Text("Pendiente")),
                    DropdownMenuItem(value: "Terminado", child: Text("Terminado")),
                  ],
                  onChanged: (value) {
                    estado = value!;
                  },
                  decoration: InputDecoration(labelText: "Estado"),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        fechaCita != null
                            ? "Fecha Cita: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(fechaCita!)}"
                            : "Seleccionar Fecha Cita",
                        overflow: TextOverflow.ellipsis, // Evita desbordamientos
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () => _seleccionarFecha(context, true),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        fechaFinalizacion != null
                            ? "Fecha Finalización: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(fechaFinalizacion!)}"
                            : "Seleccionar Fecha Finalización",
                        overflow: TextOverflow.ellipsis, // Evita desbordamientos
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () => _seleccionarFecha(context, false),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "Vehículo de ocasión: ${vehiculoOcasionId != null ? 'Seleccionado' : 'No seleccionado'}",
                        overflow: TextOverflow.ellipsis, // Evita desbordamientos
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.car_repair),
                      onPressed: _seleccionarVehiculo,
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                final datosActualizados = {
                  "diagnostico": diagnosticoController.text,
                  "estado": estado,
                  "fechaCita": fechaCita?.toIso8601String(),
                  "fechaReparacionFinalizada": fechaFinalizacion?.toIso8601String(),
                  "vehiculoOcasionId": vehiculoOcasionId
                };

                _actualizarCita(cita['id'], datosActualizados);
                Navigator.of(context).pop();
              },
              child: Text("Actualizar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Citas"),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _citas.length,
              itemBuilder: (context, index) {
                final cita = _citas[index];
                return ListTile(
                  title: Text(cita['problema'] ?? "Sin problema"),
                  subtitle: Text(cita['estado']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _mostrarDialogoActualizar(context, cita),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _cancelarCita(cita['id']),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
