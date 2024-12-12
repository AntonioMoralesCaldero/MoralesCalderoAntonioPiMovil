import 'package:flutter/material.dart';
import 'package:moralescalderoantoniopimovil/services/auth_service.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService authService = AuthService();

  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidosController = TextEditingController();
  final TextEditingController fechaNacimientoController = TextEditingController();
  final TextEditingController direccionController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  void register() async {
    setState(() {
      isLoading = true;
    });

    try {
      final Map<String, dynamic> userData = {
        "nombre": nombreController.text,
        "apellidos": apellidosController.text,
        "fecha_nacimiento": fechaNacimientoController.text,
        "direccion": direccionController.text,
        "username": usernameController.text,
        "password": passwordController.text,
      };

      await authService.register(userData);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Registro exitoso. Inicia sesión ahora."),
        backgroundColor: Colors.green,
      ));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ));
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registro de Usuario"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nombreController,
              decoration: InputDecoration(labelText: "Nombre"),
            ),
            TextField(
              controller: apellidosController,
              decoration: InputDecoration(labelText: "Apellidos"),
            ),
            TextField(
              controller: fechaNacimientoController,
              decoration: InputDecoration(
                labelText: "Fecha de Nacimiento",
              ),
              keyboardType: TextInputType.datetime,
            ),
            TextField(
              controller: direccionController,
              decoration: InputDecoration(labelText: "Dirección"),
            ),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: "Nombre de Usuario"),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "Contraseña"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : register,
              child: isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text("Registrar"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text("¿Ya tienes una cuenta? Inicia sesión aquí"),
            ),
          ],
        ),
      ),
    );
  }
}
