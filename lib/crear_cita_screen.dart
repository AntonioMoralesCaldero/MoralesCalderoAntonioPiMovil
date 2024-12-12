import 'package:flutter/material.dart';
import 'package:moralescalderoantoniopimovil/models/Cita.dart';
import 'package:moralescalderoantoniopimovil/services/cita_service.dart';
import 'package:moralescalderoantoniopimovil/services/venta_service.dart';

class CrearCitaScreen extends StatefulWidget {
  @override
  _CrearCitaScreenState createState() => _CrearCitaScreenState();
}

class _CrearCitaScreenState extends State<CrearCitaScreen> {
  final _formKey = GlobalKey<FormState>();
  final CitaService citaService = CitaService();
  final VentaService ventaService = VentaService();
  CitaModel _cita = CitaModel();
  List<dynamic> _vehiculos = [];
  int? _vehiculoSeleccionado;

  @override
  void initState() {
    super.initState();
    _cargarCochesDelUsuario();
  }

  Future<void> _cargarCochesDelUsuario() async {
    try {
      List<dynamic> vehiculos = await ventaService.obtenerCochesDelUsuario();
      setState(() {
        _vehiculos = vehiculos;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar los vehículos: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Crear Cita")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration:
                    InputDecoration(labelText: "Descripción del problema"),
                validator: (value) =>
                    value!.isEmpty ? "Este campo es obligatorio" : null,
                onSaved: (value) => _cita.problema = value,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<int>(
                decoration:
                    InputDecoration(labelText: "Selecciona un vehículo"),
                items: _vehiculos
                    .map((vehiculo) => DropdownMenuItem<int>(
                          value: vehiculo['id'],
                          child: Text(
                            vehiculo['modelo'] ??
                                'Desconocido',
                            overflow:
                                TextOverflow.ellipsis,
                          ),
                        ))
                    .toList(),
                value: _vehiculoSeleccionado,
                onChanged: (value) {
                  setState(() {
                    _vehiculoSeleccionado = value;
                    _cita.vehiculoOcasionId = value;
                  });
                },
                validator: (value) =>
                    value == null ? "Debe seleccionar un vehículo" : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _crearCita,
                child: Text("Crear Cita"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _crearCita() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        String mensaje = await citaService.crearCita(_cita);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(mensaje)));
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }
}
