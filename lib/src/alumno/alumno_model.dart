class Alumno {
  String? id;
  final String nombre;
  final String curso;
  final String dni;
  final DateTime fechaNacimiento;

  Alumno({
    this.id,
    required this.nombre,
    required this.curso,
    required this.dni,
    required this.fechaNacimiento,
  });

  // Deserialización: Desde el mapa NoSQL hacia el Objeto Dart
  factory Alumno.fromMap(Map<String, dynamic> json, String documentId) {
    return Alumno(
      id: documentId,
      nombre: json['nombre'] ?? 'Sin nombre',
      curso: json['curso'] ?? 'Sin asignar',
      dni: json['dni'] ?? 'Sin DNI',
      // Convertimos el String ISO nuevamente a un objeto DateTime
      fechaNacimiento: json['fechaNacimiento'] != null
          ? DateTime.parse(json['fechaNacimiento'])
          : DateTime.now(),
    );
  }

  // Serialización: Desde el Objeto Dart hacia el diccionario NoSQL
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'curso': curso,
      'dni': dni,
      // Firestore guarda los datos primitivos. Pasamos la fecha a String.
      'fechaNacimiento': fechaNacimiento.toIso8601String(),
    };
  }
}
