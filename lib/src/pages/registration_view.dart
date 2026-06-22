import 'package:flutter/material.dart';
import 'package:gestion_de_matriculas/src/alumno/alumno_model.dart';

class RegistrationView extends StatefulWidget {
  const RegistrationView({super.key});

  @override
  State<RegistrationView> createState() => _RegistrationViewState();
}

class _RegistrationViewState extends State<RegistrationView> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _dniController = TextEditingController();
  final TextEditingController _cursoController = TextEditingController();

  final List<String> _cursosDisponibles = [
    '1ro A',
    '2do B',
    '3ro A',
    '4to A',
    '5to B',
  ];
  String? _cursoSeleccionado;

  DateTime? _fechaSeleccionada; // Estado local para la fecha

  @override
  void dispose() {
    _nombreController.dispose();
    _dniController.dispose();
    super.dispose();
  }

  // Asynchronous interaction with the OS Calendar
  Future<void> _seleccionarFecha(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(
        const Duration(days: 365 * 6),
      ), // Start 6 years ago
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _fechaSeleccionada) {
      setState(() {
        _fechaSeleccionada = picked;
      });
    }
  }

  Future<void> _confirmSave() async {
    // Strict validation
    if (_nombreController.text.isEmpty ||
        _dniController.text.isEmpty ||
        _cursoSeleccionado == null ||
        _fechaSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, complete todos los campos obligatorios.'),
        ),
      );
      return;
    }

    final nuevoAlumno = Alumno(
      nombre: _nombreController.text,
      dni: _dniController.text,
      curso: _cursoSeleccionado!,
      fechaNacimiento: _fechaSeleccionada!,
    );

    Navigator.pop(context, nuevoAlumno);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva Inscripción')),
      body: SingleChildScrollView(
        // Changed to ScrollView to avoid keyboard overflow
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre Completo',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // DNI Input
            TextField(
              controller: _dniController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'DNI',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            DropdownMenu<String>(
              controller: _cursoController,
              label: const Text('Seleccionar Curso'),
              width: MediaQuery.of(context).size.width - 48,
              dropdownMenuEntries: _cursosDisponibles.map((String curso) {
                return DropdownMenuEntry<String>(value: curso, label: curso);
              }).toList(),
              onSelected: (String? newValue) {
                setState(() {
                  _cursoSeleccionado = newValue;
                });
              },
            ),
            const SizedBox(height: 20),

            // DatePicker
            InkWell(
              onTap: () => _seleccionarFecha(context),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Fecha de Nacimiento',
                  border: OutlineInputBorder(),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _fechaSeleccionada == null
                          ? 'Seleccione una fecha'
                          : "${_fechaSeleccionada!.day}/${_fechaSeleccionada!.month}/${_fechaSeleccionada!.year}",
                    ),
                    const Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),

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
