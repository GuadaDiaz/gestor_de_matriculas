import 'package:flutter/material.dart';
import 'package:gestion_de_matriculas/src/alumno/alumno_model.dart';

class AlumnoCard extends StatelessWidget {
  final Alumno alumno;

  const AlumnoCard({super.key, required this.alumno});

  @override
  Widget build(BuildContext context) {
    // Formatting the date for display
    final String fechaFormateada =
        "${alumno.fechaNacimiento.day}/${alumno.fechaNacimiento.month}/${alumno.fechaNacimiento.year}";

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person, color: Theme.of(context).colorScheme.primary, size: 40),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        alumno.nombre,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'DNI: ${alumno.dni}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                // Badge for the course
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    alumno.curso,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                const Icon(Icons.cake, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  'Nacimiento: $fechaFormateada',
                  style: const TextStyle(color: Colors.black87),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
