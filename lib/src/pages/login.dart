import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gestion_de_matriculas/src/pages/alumno.dart';
import 'package:gestion_de_matriculas/src/pages/docente.dart';
import 'package:gestion_de_matriculas/src/pages/qr_login_scanner.dart';

class FormularioLogin extends StatefulWidget {
  const FormularioLogin({super.key});

  @override
  State<FormularioLogin> createState() => _FormularioLoginState();
}

class _FormularioLoginState extends State<FormularioLogin> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? rolElegido;

  bool _obscurePassword = true;
  bool _isLoading = false; // Evita toques dobles al procesar

  // Se ejecuta automáticamente antes de destruir la pantalla para liberar memoria.
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _iniciarSesionConQR() async {
    final String? qrData = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QRLoginScanner()),
    );

    if (!mounted) return;

    if (qrData != null) {
      String datosLeidos = qrData.toLowerCase();

      if (datosLeidos.contains('alumno')) {
        // 1. Mostramos que está cargando
        setState(() => _isLoading = true);

        try {
          // 2. Buscamos un alumno real en Firebase (igual que el botón normal)
          final snapshot = await FirebaseFirestore.instance
              .collection('alumnos')
              .limit(1)
              .get();

          if (!mounted) return;

          // 3. Validamos si hay alumnos
          if (snapshot.docs.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'No hay alumnos registrados en la base de datos.',
                ),
              ),
            );
            return;
          }

          // 4. Navegamos a la pantalla pasándole el ID real
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PantallaAlumno(
                alumnoId: snapshot.docs.first.id, // ID real de Firebase
              ),
            ),
          );
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error de conexión: $e')));
          }
        } finally {
          if (mounted) setState(() => _isLoading = false);
        }
      } else if (datosLeidos.contains('docente')) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PantallaDocente()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error: Código QR no reconocido en el sistema.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 45,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const Icon(Icons.school, size: 45, color: Colors.white),
            ),
            const SizedBox(height: 16),
            const Text(
              'Iniciar Sesión',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email o Username',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Rol',
                  prefixIcon: Icon(Icons.admin_panel_settings),
                  border: OutlineInputBorder(),
                ),
                items: ['Alumno', 'Docente'].map((String rol) {
                  return DropdownMenuItem<String>(value: rol, child: Text(rol));
                }).toList(),
                onChanged: (nuevoRol) {
                  setState(() {
                    rolElegido = nuevoRol;
                  });
                },
              ),
            ),
            const SizedBox(height: 30),

            // --- BOTÓN NORMAL (CON CORREO Y CONTRASEÑA) ---
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () async {
                      if (_emailController.text.trim().isEmpty ||
                          _passwordController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Error: Credenciales incompletas.'),
                          ),
                        );
                        return;
                      }

                      // Validación del estado local antes de procesar la lógica de negocio
                      if (rolElegido == null) {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Por favor, seleccione un rol primero',
                            ),
                          ),
                        );
                        return;
                      }

                      if (rolElegido == 'Alumno') {
                        setState(() => _isLoading = true);

                        final messenger = ScaffoldMessenger.of(context);
                        final navigator = Navigator.of(context);

                        try {
                          final snapshot = await FirebaseFirestore.instance
                              .collection('alumnos')
                              .limit(1)
                              .get();

                          if (!mounted) return;

                          if (snapshot.docs.isEmpty) {
                            messenger.showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'No hay alumnos registrados aún. Pedile al docente que te inscriba primero.',
                                ),
                              ),
                            );
                            return;
                          }

                          // Mutación destructiva de la pila de navegación
                          navigator.pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => PantallaAlumno(
                                alumnoId: snapshot.docs.first.id,
                              ),
                            ),
                          );
                        } catch (e) {
                          if (mounted) {
                            messenger.showSnackBar(
                              SnackBar(content: Text('Error de conexión: $e')),
                            );
                          }
                        } finally {
                          if (mounted) setState(() => _isLoading = false);
                        }
                      } else if (rolElegido == 'Docente') {
                        // Mutación destructiva de la pila de navegación
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PantallaDocente(),
                          ),
                        );
                      }
                    },
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Text('Acceder', style: TextStyle(fontSize: 18)),
                    ),
            ),

            const SizedBox(height: 15),

            // --- BOTÓN QR
            OutlinedButton.icon(
              onPressed: _iniciarSesionConQR,
              icon: const Icon(Icons.qr_code_scanner, size: 24),
              label: const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text('Entrar con QR', style: TextStyle(fontSize: 16)),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
