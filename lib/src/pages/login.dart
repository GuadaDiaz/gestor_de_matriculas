import 'package:flutter/material.dart';
import 'package:gestion_de_matriculas/src/pages/alumno.dart';
import 'package:gestion_de_matriculas/src/pages/docente.dart';

class FormularioLogin extends StatefulWidget {
  const FormularioLogin({super.key});

  @override
  State<FormularioLogin> createState() => _FormularioLoginState();
}

class _FormularioLoginState extends State<FormularioLogin> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? rolElegido;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Iniciar Sesión',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email o Username',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 30),
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
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
              ),
              onPressed: () {
                if (_emailController.text.trim().isEmpty ||
                    _passwordController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Error: Credenciales incompletas.'),
                    ),
                  );
                  return; // Early return, corta la ejecución
                }

                // Validación del estado local antes de procesar la lógica de negocio
                if (rolElegido == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor, seleccione un rol primero'),
                    ),
                  );
                  return; // Early return para evitar anidar lógica innecesariamente
                }

                // Mutación destructiva de la pila de navegación
                if (rolElegido == 'Alumno') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PantallaAlumno(),
                    ),
                  );
                } else if (rolElegido == 'Docente') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PantallaDocente(),
                    ),
                  );
                }
              },
              child: const Text(
                'Acceder',
                style: TextStyle(fontSize: 18, color: Color(0xFF0D47A1)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
