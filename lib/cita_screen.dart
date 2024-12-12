import 'package:flutter/material.dart';
import 'package:moralescalderoantoniopimovil/models/Cita.dart';
import 'package:moralescalderoantoniopimovil/services/cita_service.dart';
import 'package:moralescalderoantoniopimovil/valorar_cita_screen.dart';
import 'package:moralescalderoantoniopimovil/ver_editar_valoracion_screen.dart';

class CitaScreen extends StatefulWidget {
  @override
  _CitaScreenState createState() => _CitaScreenState();
}

class _CitaScreenState extends State<CitaScreen> {
  late Future<List<CitaModel>> citas;

  @override
  void initState() {
    super.initState();
    citas = CitaService().obtenerCitas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mis Citas"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/nueva-cita');
            },
          ),
        ],
      ),
      body: FutureBuilder<List<CitaModel>>(
        future: citas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No tienes citas pendientes.'));
          }

          final citas = snapshot.data!;

          return ListView.builder(
            itemCount: citas.length,
            itemBuilder: (context, index) {
              final cita = citas[index];
              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(cita.problema ?? 'No disponible'),
                  subtitle: Text(
                    cita.fechaCita != null ? cita.fechaCita! : 'Sin fecha',
                  ),
                  trailing: SizedBox(
                    width:
                        120,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            cita.estado ?? 'Estado desconocido',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          if (cita.estado == 'Terminado' &&
                              cita.valorada == true)
                            Text(
                              'Valorada',
                              style: TextStyle(color: Colors.green),
                              textAlign: TextAlign.center,
                            ),
                          if (cita.estado == 'Terminado' &&
                              cita.valorada == false)
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ValorarCitaScreen(citaId: cita.id!),
                                  ),
                                );
                              },
                              child: Text(
                                'Valorar',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          if (cita.estado == 'Terminado' &&
                              cita.valorada == true)
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        VerEditarValoracionScreen(
                                            citaId: cita.id!),
                                  ),
                                );
                              },
                              child: Text(
                                'Ver/Editar',
                                textAlign: TextAlign.center,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {},
                ),
              );
            },
          );
        },
      ),
    );
  }
}
