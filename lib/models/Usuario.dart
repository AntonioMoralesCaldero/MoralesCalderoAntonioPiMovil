class Usuario {
  int? id;
  String? nombre;
  String? apellidos;
  String? fechaNacimiento;
  String? direccion;
  String? username;
  String? password;
  bool? isActive;

  Usuario({
    this.id,
    this.nombre,
    this.apellidos,
    this.fechaNacimiento,
    this.direccion,
    this.username,
    this.password,
    this.isActive = true,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      nombre: json['nombre'],
      apellidos: json['apellidos'],
      fechaNacimiento: json['fechaNacimiento'],
      direccion: json['direccion'],
      username: json['username'],
      password: json['password'],
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'apellidos': apellidos,
      'fechaNacimiento': fechaNacimiento,
      'direccion': direccion,
      'username': username,
      'password': password,
      'isActive': isActive,
    };
  }
}
