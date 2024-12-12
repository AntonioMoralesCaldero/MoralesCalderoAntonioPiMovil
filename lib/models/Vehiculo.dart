class Vehiculo {
  final int id;
  final String modelo;
  final String color;
  final double precio;
  final int potencia;
  final String imagen;
  final String matricula;
  final bool vendido;

  Vehiculo({
    required this.id,
    required this.modelo,
    required this.color,
    required this.precio,
    required this.potencia,
    required this.imagen,
    required this.matricula,
    required this.vendido,
  });

  factory Vehiculo.fromJson(Map<String, dynamic> json) {
    return Vehiculo(
      id: json['id'],
      modelo: json['modelo'],
      color: json['color'],
      precio: json['precio'].toDouble(),
      potencia: json['potencia'],
      imagen: json['imagen'],
      matricula: json['matricula'],
      vendido: json['vendido'],
    );
  }
}
