import 'package:flutter/material.dart';
import 'package:gestion_de_matriculas/src/alumno/alumno_model.dart';
import '../services/alumno_service.dart';

class RegistrationView extends StatefulWidget {
  // Para editar la carga del alumno
  final Alumno? alumnoExistente;

  const RegistrationView({super.key, this.alumnoExistente});

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
  DateTime? _fechaSeleccionada;

  bool _isEditing = false;
  bool _isLoading = false; // Para evitar cargar múltiples

  @override
  void initState() {
    super.initState();
    if (widget.alumnoExistente != null) {
      _isEditing = true;
      final alumno = widget.alumnoExistente!;

      _nombreController.text = alumno.nombre;
      _dniController.text = alumno.dni;
      _cursoSeleccionado = alumno.curso;
      _fechaSeleccionada = alumno.fechaNacimiento;
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _dniController.dispose();
    _cursoController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarFecha(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _fechaSeleccionada ??
          DateTime.now().subtract(const Duration(days: 365 * 6)),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _fechaSeleccionada) {
      setState(() => _fechaSeleccionada = picked);
    }
  }

  Future<void> _procesarFormulario() async {
    if (_nombreController.text.trim().isEmpty ||
        _dniController.text.trim().isEmpty ||
        _cursoSeleccionado == null ||
        _fechaSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Completar todos los campos es obligatorio.'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_isEditing) {
        // UPDATE
        final alumnoActualizado = Alumno(
          id: widget.alumnoExistente!.id, // Preserve the Firestore Document ID
          nombre: _nombreController.text.trim(),
          dni: _dniController.text.trim(),
          curso: _cursoSeleccionado!,
          fechaNacimiento: _fechaSeleccionada!,
        );
        await AlumnoService.instance.actualizarAlumno(alumnoActualizado);
      } else {
        // CREATE
        final nuevoAlumno = Alumno(
          nombre: _nombreController.text.trim(),
          dni: _dniController.text.trim(),
          curso: _cursoSeleccionado!,
          fechaNacimiento: _fechaSeleccionada!,
        );
        await AlumnoService.instance.registrarAlumno(nuevoAlumno);
      }

      // Vuelve a la página anterior
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error de red: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Matrícula' : 'Nueva Inscripción'),
      ),
      body: SingleChildScrollView(
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
              initialSelection: _cursoSeleccionado,
              dropdownMenuEntries: _cursosDisponibles.map((String curso) {
                return DropdownMenuEntry<String>(value: curso, label: curso);
              }).toList(),
              onSelected: (String? newValue) =>
                  setState(() => _cursoSeleccionado = newValue),
            ),
            const SizedBox(height: 20),
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
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _procesarFormulario,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        _isEditing
                            ? 'Actualizar Matrícula'
                            : 'Guardar Registro',
                        style: const TextStyle(fontSize: 18),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
