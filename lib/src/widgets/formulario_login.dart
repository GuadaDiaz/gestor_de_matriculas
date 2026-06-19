import 'package:flutter/material.dart';
import 'package:mi_app/src/screens/alumno.dart';
import 'package:mi_app/src/screens/docente.dart';

class FormularioLogin extends StatefulWidget {
  const FormularioLogin({super.key});

  @override
  State<FormularioLogin> createState() => _FormularioLoginState();
}

class _FormularioLoginState extends State<FormularioLogin> {
  // 1. Creamos una variable para "recordar" el rol seleccionado
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
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email o Username',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
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
                  return DropdownMenuItem<String>(
                    value: rol,
                    child: Text(rol),
                  );
                }).toList(),
                onChanged: (nuevoRol) {
                  // 2. Guardamos la selección del usuario en la variable
                  setState(() {
                    rolElegido = nuevoRol;
                  });
                },
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              onPressed: () {
                // 3. Verificamos la variable y navegamos a la pantalla correspondiente
                if (rolElegido == 'Alumno') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PantallaAlumno()),
                  );
                } else if (rolElegido == 'Docente') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PantallaDocente()),
                  );
                } else {
                  // Muestra un cartelito si tocan el botón sin elegir rol
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Por favor, seleccione un rol primero')),
                  );
                }
              },
              child: const Text('Acceder', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}



