import 'package:flutter/material.dart';
import 'package:moralescalderoantoniopimovil/services/valoracion_service.dart';

class VerEditarValoracionScreen extends StatefulWidget {
  final int citaId;

  VerEditarValoracionScreen({required this.citaId});

  @override
  _VerEditarValoracionScreenState createState() => _VerEditarValoracionScreenState();
}

class _VerEditarValoracionScreenState extends State<VerEditarValoracionScreen> {
  final ValoracionService _valoracionService = ValoracionService();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = true;
  bool isSubmitting = false;

  int? _puntuacion;
  late TextEditingController _comentarioController;

  @override
  void initState() {
    super.initState();
    _comentarioController = TextEditingController();
    _cargarValoracion();
  }

  Future<void> _cargarValoracion() async {
    try {
      final valoracion = await _valoracionService.obtenerValoracion(widget.citaId);
      setState(() {
        _puntuacion = valoracion['puntuacion'];
        _comentarioController.text = valoracion['comentario'];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar la valoración: $e')),
      );
    }
  }

  Future<void> _guardarCambios() async {
    if (_puntuacion == null || _comentarioController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, completa todos los campos.')),
      );
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      await _valoracionService.editarValoracion(
        widget.citaId,
        _puntuacion!,
        _comentarioController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('¡Valoración actualizada con éxito!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar: $e')),
      );
    } finally {
      setState(() {
        isSubmitting = false;
      });
    }
  }

  @override
  void dispose() {
    _comentarioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ver/Editar Valoración'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Puntuación:', style: TextStyle(fontSize: 18)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(
                            _puntuacion != null && _puntuacion! > index
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.yellow,
                          ),
                          onPressed: () {
                            setState(() {
                              _puntuacion = index + 1;
                            });
                          },
                        );
                      }),
                    ),
                    SizedBox(height: 16),
                    Text('Comentario:', style: TextStyle(fontSize: 18)),
                    TextFormField(
                      controller: _comentarioController,
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
                            onPressed: _guardarCambios,
                            child: Text('Guardar Cambios'),
                          ),
                  ],
                ),
              ),
            ),
    );
  }
}
