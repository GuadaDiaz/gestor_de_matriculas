import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:gestion_de_matriculas/src/alumno/alumno_model.dart';
import 'package:gestion_de_matriculas/src/services/alumno_service.dart';

class PantallaAlumno extends StatefulWidget {
  final String alumnoId;

  const PantallaAlumno({super.key, required this.alumnoId});

  @override
  State<PantallaAlumno> createState() => _PantallaAlumnoState();
}

class _PantallaAlumnoState extends State<PantallaAlumno> {
  // --- Controladores de texto ---
  final _nombreController = TextEditingController();
  final _dniController = TextEditingController();

  // --- Estado ---
  Alumno? _alumno;
  DateTime? _fechaNacimiento;
  File? _fotoLocal;
  bool _isLoading = true;
  bool _isSaving = false;

  // --- ImagePicker ---
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _dniController.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────
  // CARGA DE DATOS
  // ─────────────────────────────────────────

  Future<void> _cargarDatos() async {
    // Cargar datos del alumno desde Firestore
    final alumno = await AlumnoService.instance.getAlumnoPorId(widget.alumnoId);

    // Cargar foto local si existe
    File? fotoGuardada;
    try {
      final dir = await getApplicationDocumentsDirectory();
      final ruta = '${dir.path}/perfil_${widget.alumnoId}.jpg';
      final archivo = File(ruta);
      if (await archivo.exists()) {
        fotoGuardada = archivo;
      }
    } catch (_) {}

    if (mounted) {
      setState(() {
        _alumno = alumno;
        _fotoLocal = fotoGuardada;
        _isLoading = false;
        if (alumno != null) {
          _nombreController.text = alumno.nombre;
          _dniController.text = alumno.dni;
          _fechaNacimiento = alumno.fechaNacimiento;
        }
      });
    }
  }

  // ─────────────────────────────────────────
  // FOTO DE PERFIL — Flujo principal
  // ─────────────────────────────────────────

  /// Muestra el BottomSheet para elegir fuente de la foto
  void _mostrarOpcionesFoto() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Foto de perfil',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  child: Icon(
                    Icons.camera_alt,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                title: const Text('Tomar foto'),
                subtitle: const Text('Usar la cámara del dispositivo'),
                onTap: () {
                  Navigator.pop(ctx);
                  _seleccionarImagen(ImageSource.camera);
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                  child: Icon(
                    Icons.photo_library,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                title: const Text('Elegir de la galería'),
                subtitle: const Text('Seleccionar desde tus fotos'),
                onTap: () {
                  Navigator.pop(ctx);
                  _seleccionarImagen(ImageSource.gallery);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  /// Maneja el flujo de permisos y apertura del picker
  Future<void> _seleccionarImagen(ImageSource fuente) async {
    // La galería usa el Photo Picker nativo en Android 13+ (no necesita permiso)
    // Solo la cámara requiere verificar permisos manualmente
    if (fuente == ImageSource.camera) {
      final permisoConcedido = await _verificarPermisoCamara();
      if (!permisoConcedido) return;
    }

    try {
      final XFile? imagen = await _picker.pickImage(
        source: fuente,
        maxWidth: 400,
        maxHeight: 400,
        imageQuality: 75,
      );

      if (imagen == null) return; // El usuario canceló

      await _guardarFotoLocal(imagen);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al obtener la imagen: $e')),
        );
      }
    }
  }

  /// Verifica y solicita el permiso de cámara. Retorna true si está concedido.
  Future<bool> _verificarPermisoCamara() async {
    PermissionStatus estado = await Permission.camera.status;

    if (estado.isGranted) return true;

    if (estado.isDenied) {
      // Primera vez o negado anteriormente → solicitar
      estado = await Permission.camera.request();
      if (estado.isGranted) return true;
    }

    if (estado.isPermanentlyDenied) {
      // El usuario marcó "No volver a preguntar" → dirigir a ajustes
      if (mounted) _mostrarDialogoAjustes();
      return false;
    }

    // Denegado sin "No volver a preguntar"
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Permiso de cámara denegado.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
    return false;
  }

  /// Diálogo para cuando el permiso fue denegado permanentemente
  void _mostrarDialogoAjustes() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Permiso de cámara'),
        content: const Text(
          'El permiso de cámara fue denegado permanentemente.\n\n'
          'Para habilitar la cámara, ve a Ajustes → Aplicaciones → '
          'Gestión Matrículas → Permisos → Cámara.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              openAppSettings(); // Abre los ajustes del sistema
            },
            child: const Text('Ir a Ajustes'),
          ),
        ],
      ),
    );
  }

  /// Guarda la imagen en el directorio local de la app
  Future<void> _guardarFotoLocal(XFile imagen) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final destino = File('${dir.path}/perfil_${widget.alumnoId}.jpg');
      await File(imagen.path).copy(destino.path);

      if (mounted) {
        setState(() => _fotoLocal = destino);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Foto actualizada correctamente'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar la foto: $e')),
        );
      }
    }
  }

  // ─────────────────────────────────────────
  // DATOS PERSONALES — Guardar
  // ─────────────────────────────────────────

  Future<void> _seleccionarFecha() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fechaNacimiento ??
          DateTime.now().subtract(const Duration(days: 365 * 15)),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _fechaNacimiento) {
      setState(() => _fechaNacimiento = picked);
    }
  }

  Future<void> _guardarCambios() async {
    if (_alumno == null) return;

    if (_nombreController.text.trim().isEmpty ||
        _dniController.text.trim().isEmpty ||
        _fechaNacimiento == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completá todos los campos.')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final actualizado = Alumno(
        id: _alumno!.id,
        nombre: _nombreController.text.trim(),
        dni: _dniController.text.trim(),
        curso: _alumno!.curso,
        fechaNacimiento: _fechaNacimiento!,
      );
      await AlumnoService.instance.actualizarAlumno(actualizado);

      if (mounted) {
        setState(() => _alumno = actualizado);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Perfil actualizado correctamente'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  // ─────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil Alumno'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar Sesión',
            onPressed: () => Navigator.pushReplacementNamed(context, '/'),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _alumno == null
              ? _buildErrorWidget()
              : _buildPerfil(),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('No se encontraron los datos del alumno.'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() => _isLoading = true);
              _cargarDatos();
            },
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  Widget _buildPerfil() {
    final colorScheme = Theme.of(context).colorScheme;
    final String fechaFormateada = _fechaNacimiento != null
        ? '${_fechaNacimiento!.day}/${_fechaNacimiento!.month}/${_fechaNacimiento!.year}'
        : 'Seleccionar fecha';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── FOTO DE PERFIL ──
          Center(
            child: Column(
              children: [
                GestureDetector(
                  onTap: _mostrarOpcionesFoto,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 64,
                        backgroundColor: colorScheme.primaryContainer,
                        backgroundImage: _fotoLocal != null
                            ? FileImage(_fotoLocal!)
                            : null,
                        child: _fotoLocal == null
                            ? Icon(
                                Icons.person,
                                size: 64,
                                color: colorScheme.primary,
                              )
                            : null,
                      ),
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: colorScheme.primary,
                        child: const Icon(
                          Icons.camera_alt,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                TextButton.icon(
                  onPressed: _mostrarOpcionesFoto,
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Cambiar foto'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── DATOS PERSONALES ──
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.person_outline, color: colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        'Datos Personales',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Divider(height: 24),

                  // Nombre
                  TextField(
                    controller: _nombreController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre completo',
                      prefixIcon: Icon(Icons.badge_outlined),
                      border: OutlineInputBorder(),
                    ),
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 16),

                  // DNI
                  TextField(
                    controller: _dniController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'DNI',
                      prefixIcon: Icon(Icons.credit_card_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Fecha de nacimiento
                  InkWell(
                    onTap: _seleccionarFecha,
                    borderRadius: BorderRadius.circular(12),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Fecha de nacimiento',
                        prefixIcon: Icon(Icons.calendar_today_outlined),
                        border: OutlineInputBorder(),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(fechaFormateada),
                          Icon(Icons.arrow_drop_down,
                              color: colorScheme.primary),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Curso (solo lectura)
                  InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Curso',
                      prefixIcon: const Icon(Icons.class_outlined),
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                    child: Text(
                      _alumno!.curso,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // ── BOTÓN GUARDAR ──
          SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: _isSaving ? null : _guardarCambios,
              icon: _isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                  : const Icon(Icons.save_outlined),
              label: Text(_isSaving ? 'Guardando...' : 'Guardar Cambios'),
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
