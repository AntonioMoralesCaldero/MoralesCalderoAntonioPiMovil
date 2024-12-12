import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moralescalderoantoniopimovil/services/venta_service.dart';
import 'package:permission_handler/permission_handler.dart';

class VenderCocheScreen extends StatefulWidget {
  @override
  _VenderCocheScreenState createState() => _VenderCocheScreenState();
}

class _VenderCocheScreenState extends State<VenderCocheScreen> {
  final _formKey = GlobalKey<FormState>();
  final VentaService ventaService = VentaService();
  final Map<String, String> _datosVehiculo = {};
  File? _imagen;


Future<void> _seleccionarImagen() async {
  var status = await Permission.photos.request(); 

  if (status.isGranted) {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imagen = File(pickedFile.path);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No se seleccionó ninguna imagen.")),
      );
    }
  } else if (status.isDenied) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Permiso denegado para acceder a las fotos.")),
    );
  } else if (status.isPermanentlyDenied) {
    openAppSettings();
  }
}

void openAppSettings() async {
  openAppSettings(); 
}





  Future<void> _enviarFormulario() async {
    if (!_formKey.currentState!.validate() || _imagen == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Completa todos los campos y selecciona una imagen."),
      ));
      return;
    }

    _formKey.currentState!.save();

    try {
      final mensaje = await ventaService.agregarVehiculo(_datosVehiculo, _imagen!.path);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensaje)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Vender tu Coche")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Modelo"),
                validator: (value) => value!.isEmpty ? "Campo requerido" : null,
                onSaved: (value) => _datosVehiculo['modelo'] = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Color"),
                onSaved: (value) => _datosVehiculo['color'] = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Precio"),
                keyboardType: TextInputType.number,
                onSaved: (value) => _datosVehiculo['precio'] = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Potencia"),
                keyboardType: TextInputType.number,
                onSaved: (value) => _datosVehiculo['potencia'] = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Matricula"),
                onSaved: (value) => _datosVehiculo['matricula'] = value!,
              ),
              SizedBox(height: 20),
              _imagen == null
                  ? Text("No se ha seleccionado una imagen.")
                  : Image.file(_imagen!),
              ElevatedButton(
                onPressed: _seleccionarImagen,
                child: Text("Seleccionar Imagen"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _enviarFormulario,
                child: Text("Vender Coche"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
