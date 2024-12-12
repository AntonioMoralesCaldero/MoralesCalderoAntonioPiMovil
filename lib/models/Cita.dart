import 'package:moralescalderoantoniopimovil/models/Usuario.dart';

class CitaModel {
  int? id;
  String? problema;
  String? fechaCita;
  String? estado;
  String? diagnostico;
  String? fechaReparacionFinalizada;
  Usuario? usuario;
  int? vehiculoOcasionId;
  bool? valorada;

  CitaModel({
    this.id,
    this.problema,
    this.fechaCita,
    this.estado,
    this.diagnostico,
    this.fechaReparacionFinalizada,
    this.usuario,
    this.vehiculoOcasionId,
    this.valorada,
  });

  factory CitaModel.fromJson(Map<String, dynamic> json) {
    return CitaModel(
      id: json['id'],
      problema: json['problema'],
      fechaCita: json['fechaCita'],
      estado: json['estado'],
      diagnostico: json['diagnostico'],
      fechaReparacionFinalizada: json['fechaReparacionFinalizada'],
      usuario: Usuario.fromJson(json['usuario']),
      vehiculoOcasionId: json['vehiculoOcasionId'],
      valorada: json['valorada'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'problema': problema,
      'vehiculoOcasionId': vehiculoOcasionId,
    };
  }
}
