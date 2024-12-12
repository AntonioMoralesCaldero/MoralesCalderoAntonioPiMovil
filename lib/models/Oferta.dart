class Oferta {
  int? id;
  String modelo;
  String color;
  double precio;
  int potencia;
  String? imagen;
  String? estado;
  String matricula;

  Oferta({
    this.id,
    required this.modelo,
    required this.color,
    required this.precio,
    required this.potencia,
    this.imagen,
    this.estado,
    required this.matricula,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'modelo': modelo,
      'color': color,
      'precio': precio,
      'potencia': potencia,
      'imagen': imagen,
      'estado': estado,
      'matricula': matricula,
    };
  }

  factory Oferta.fromJson(Map<String, dynamic> json) {
    return Oferta(
      id: json['id'],
      modelo: json['modelo'],
      color: json['color'],
      precio: json['precio'].toDouble(),
      potencia: json['potencia'],
      imagen: json['imagen'],
      estado: json['estado'],
      matricula: json['matricula'],
    );
  }
}
