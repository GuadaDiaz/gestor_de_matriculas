import 'package:flutter/material.dart';

class Novedades extends StatelessWidget {
  const Novedades({super.key});

  @override
  Widget build(BuildContext context) {
  
    final List<Map<String, String>> listaNoticias = [
      {
        'titulo': '📢 ¡INSCRIPCIONES ABIERTAS!',
        'fecha': '22 Jun 2026',
        'descripcion': 'Ya se encuentran abiertas las inscripciones para nuestro próximo ciclo de actividades. Si estás interesado, no pierdas esta oportunidad!',
        'imagen': 'assets/incripciones.png'
      },
      {
        'titulo': '🔬 Feria de Ciencias 2026',
        'fecha': '15 Jun 2026',
        'descripcion': 'La institución invita a toda la comunidad educativa a participar de la Feria de Ciencias, un espacio donde los estudiantes presentarán proyectos innovadores, experimentos y trabajos de investigación desarrollados durante el año.',
        'imagen': 'assets/feria.png'
      },
      {
        'titulo': '👨‍👩‍👧‍👦 Reunión de Padres',
        'fecha': '10 Jun 2026',
        'descripcion': 'Se invita a todos los padres y tutores a participar de la próxima reunión informativa, un espacio destinado a compartir novedades, dialogar sobre el desarrollo de los estudiantes y fortalecer el trabajo conjunto entre la familia y la institución.',
        'imagen': 'assets/reunionpadres.png'
      },
    ];
    return ListView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: listaNoticias.length,
      itemBuilder: (context, index) {
        final noticia = listaNoticias[index]; 
        
        return Center( 
          child: ConstrainedBox(
           
            constraints: const BoxConstraints(maxWidth: 800), 
            child: Card(
              margin: const EdgeInsets.only(bottom: 20), 
              elevation: 4,
              clipBehavior: Clip.antiAlias, 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                
                  Image.network(
                    noticia['imagen']!,
                    height: 450,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          noticia['titulo']!,
                          style: const TextStyle(
                            fontSize: 22, 
                            fontWeight: FontWeight.bold, 
                            color: Color(0xFF0D47A1),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          noticia['fecha']!,
                          style: const TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          noticia['descripcion']!,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
