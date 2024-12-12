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
