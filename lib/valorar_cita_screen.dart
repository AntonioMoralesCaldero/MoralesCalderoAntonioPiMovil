import 'package:flutter/material.dart';
import 'package:moralescalderoantoniopimovil/services/valoracion_service.dart';

class ValorarCitaScreen extends StatefulWidget {
  final int citaId;

  const ValorarCitaScreen({Key? key, required this.citaId}) : super(key: key);

  @override
  _ValorarCitaScreenState createState() => _ValorarCitaScreenState();
}

class _ValorarCitaScreenState extends State<ValorarCitaScreen> {
  int? puntuacion;
  TextEditingController comentarioController = TextEditingController();
  bool isSubmitting = false;

  void guardarValoracion() async {
    if (puntuacion == null || comentarioController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, completa todos los campos.')),
      );
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      await ValoracionService().guardarValoracion(
        widget.citaId,
        puntuacion!,
        comentarioController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('¡Valoración guardada con éxito!')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar la valoración: $e')),
      );
    } finally {
      setState(() {
        isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Valorar Cita')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Puntuación:', style: TextStyle(fontSize: 18)),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    puntuacion != null && puntuacion! > index
                        ? Icons.star
                        : Icons.star_border,
                    color: Colors.yellow,
                  ),
                  onPressed: () {
                    setState(() {
                      puntuacion = index + 1;
                    });
                  },
                );
              }),
            ),
            SizedBox(height: 16),
            Text('Comentario:', style: TextStyle(fontSize: 18)),
            TextField(
              controller: comentarioController,
              maxLines: 3,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Escribe un comentario...',
              ),
            ),
            SizedBox(height: 16),
            isSubmitting
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: guardarValoracion,
                    child: Text('Guardar Valoración'),
                  ),
          ],
        ),
      ),
    );
  }
}
