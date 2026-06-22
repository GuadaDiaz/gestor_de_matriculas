import 'package:flutter/material.dart'; // Importa tu archivo de rutas

class PantallaDocente extends StatelessWidget {
  const PantallaDocente({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil Docente'),
        centerTitle: true,
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          // Background Layer
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/fondo_docente.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Color(0xDD000033),
                  BlendMode.darken,
                ),
              ),
            ),
          ),

          // Foreground Layer: Interactivity and Navigation
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.school, size: 80, color: Color(0xFF0D47A1)),
                const SizedBox(height: 20),
                const Text(
                  'Gestión Académica',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D47A1),
                  ),
                ),
                const SizedBox(height: 40),

                // Navigation Button 1: Inscribir Alumno
                ElevatedButton.icon(
                  icon: const Icon(Icons.person_add, color: Color(0xFF0D47A1)),
                  label: const Text(
                    'Inscribir Alumno',
                    style: TextStyle(fontSize: 16, color: Color(0xFF0D47A1)),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                  ),
                  onPressed: () {
                    // Centralized navigation pushing the registration view onto the stack
                    Navigator.pushNamed(context, '/registro');
                  },
                ),

                const SizedBox(height: 20),

                // Navigation Button 2: Ver Dashboard
                ElevatedButton.icon(
                  icon: const Icon(Icons.dashboard),
                  label: const Text(
                    'Ver Matrículas',
                    style: TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF0D47A1),
                  ),
                  onPressed: () {
                    // Navigating to the Dashboard
                    Navigator.pushNamed(context, '/dashboard');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
