import 'package:flutter/material.dart';
import 'package:moralescalderoantoniopimovil/index_sreen.dart';
import 'package:moralescalderoantoniopimovil/register_screen.dart';
import 'package:moralescalderoantoniopimovil/services/auth_service.dart';
import 'admin_index_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();
  bool isLoading = false;

  void login() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await authService.login(
        usernameController.text,
        passwordController.text,
      );

      final String username = usernameController.text;
      final String password = passwordController.text;

      if (username == 'adminMovil' && password == '1234') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminIndexScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => IndexScreen()),
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Inicio de sesión exitoso"),
        backgroundColor: Colors.green,
      ));
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
        title: Text("Inicio de Sesión"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: "Usuario"),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "Contraseña"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : login,
              child: isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text("Iniciar Sesión"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
              child: Text("¿No tienes una cuenta? Regístrate aquí"),
            ),
          ],
        ),
      ),
    );
  }
}
