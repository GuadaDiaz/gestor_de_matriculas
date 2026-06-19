import 'package:flutter/material.dart';

class PantallaAlumno extends StatelessWidget {
  const PantallaAlumno({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil Alumno'),
        backgroundColor: Colors.green, // Color distinto para notar el cambio
      ),
      body: const Center(
        child: Text('¡Bienvenido a la sección de Alumnos!', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}