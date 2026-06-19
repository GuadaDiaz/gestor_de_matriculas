import 'package:flutter/material.dart';

class PantallaDocente extends StatelessWidget {
  const PantallaDocente({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil Docente'),
        centerTitle: true,
        backgroundColor: const Color(0xFF0D47A1), // Unificamos el azul oscuro
        foregroundColor: Colors.white,
      ),

      // Usamos Stack para poner la imagen de fondo y la lista encima
      body: Stack(
        children: [

          // --- 1. EL FONDO OSCURO ---
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                // Acá pondrás el Image.asset de la escuela cuando la tengas
                image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Color(0xDD000033), // Azul muy oscuro casi negro, semi-transparente
                  BlendMode.darken,
                ),
              ),
            ),
          ),

          // --- 2. EL CONTENIDO (Título y Lista) ---
          Column(
            children: [
              const SizedBox(height: 30),

              // Título Principal
              const Text(
                'PERFIL\nDOCENTE',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  height: 1.0, // Acerca las dos palabras verticalmente
                ),
              ),

              const SizedBox(height: 40),

              // La Lista de Materias
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    // Llamamos a nuestro "molde" con los 4 parámetros dinámicos correspondientes
                    _crearTarjetaMateria('Matemática', '3° Año', 'Mañana', 'assets/descarga.jpg'),
                    _crearTarjetaMateria('Historia', '4° Año', 'Tarde', 'assets/historia.jpg'),
                    _crearTarjetaMateria('Programación', '5° Año', 'Mañana', 'assets/python.jpg'),
                    _crearTarjetaMateria('Literatura', '2° Año', 'Tarde', 'assets/literatura.jpg'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // MOLDE ACTUALIZADO: Ahora recibe 4 datos, incluyendo la ruta de la imagen
  // =========================================================================
  Widget _crearTarjetaMateria(String materia, String curso, String turno, String rutaImagen) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20), // Separación entre materias
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          // 1. Cajita de la izquierda (La Imagen dinámica)
          Container(
            width: 80,
            height: 80,
            color: Colors.white,
            child: Center(
              child: Image.asset(rutaImagen), // Reemplazamos el texto fijo por la variable
            ),
          ),

          const SizedBox(width: 20), // Espacio entre la cajita y los textos

          // 2. Textos de la derecha
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$curso - $materia',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Turno $turno',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

        ], // Cierra los children del Row
      ), // Cierra el Row
    ); // Cierra el Padding
  } // Cierra el método _crearTarjetaMateria
} // Cierra la clase PantallaDocente