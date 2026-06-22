import 'package:flutter/material.dart';
import 'package:gestion_de_matriculas/src/Alumno/alumno_model.dart';

class RegistrationView extends StatefulWidget {
  const RegistrationView({super.key});

  @override
  State<RegistrationView> createState() => _RegistrationViewState();
}

class _RegistrationViewState extends State<RegistrationView> {
  final TextEditingController _nombreController = TextEditingController();

  // State for the Dropdown
  final List<String> _cursosDisponibles = [
    '1ro A',
    '2do B',
    '3ro A',
    '4to A',
    '5to B',
  ];
  String? _cursoSeleccionado;

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }

  // Requirement: AlertDialog to interrupt user flow
  Future<void> _confirmSave() async {
    if (_nombreController.text.isEmpty || _cursoSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, complete todos los campos.')),
      );
      return;
    }

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Inscripción'),
          content: Text('¿Desea registrar a ${_nombreController.text}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      if (!mounted) return;
      final nuevoAlumno = Alumno(
        nombre: _nombreController.text,
        curso: _cursoSeleccionado!,
      );
      Navigator.pop(context, nuevoAlumno);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva Inscripción')),
      // Requirement: Container structuring with padding
      body: Container(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre Completo del Alumno',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Seleccionar Curso',
                border: OutlineInputBorder(),
              ),
              initialValue: _cursoSeleccionado,
              items: _cursosDisponibles.map((String curso) {
                return DropdownMenuItem<String>(
                  value: curso,
                  child: Text(curso),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _cursoSeleccionado = newValue;
                });
              },
            ),
            const Spacer(),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: _confirmSave,
              child: const Text(
                'Guardar Registro',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
