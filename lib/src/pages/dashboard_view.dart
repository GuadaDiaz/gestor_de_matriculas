import 'package:flutter/material.dart';
import 'package:gestion_de_matriculas/src/alumno/alumno_model.dart';
import 'package:gestion_de_matriculas/src/pages/registration_view.dart';
import '../services/alumno_service.dart';
import '../widgets/alumno_card.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({
    super.key,
  }); // Ahora puede ser Stateless, el StreamBuilder maneja el estado

  Map<String, List<Alumno>> _agruparPorCurso(List<Alumno> listaPlana) {
    final Map<String, List<Alumno>> mapa = {};
    for (var alumno in listaPlana) {
      if (!mapa.containsKey(alumno.curso)) {
        mapa[alumno.curso] = [];
      }
      mapa[alumno.curso]!.add(alumno);
    }
    return mapa;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard de Matrícula')),
      body: StreamBuilder<List<Alumno>>(
        stream: AlumnoService.instance.getAlumnosStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error de sincronización: ${snapshot.error}'),
            );
          }

          final alumnos = snapshot.data ?? [];
          if (alumnos.isEmpty) {
            return const Center(
              child: Text("No hay alumnos registrados en la nube."),
            );
          }

          final alumnosAgrupados = _agruparPorCurso(alumnos);
          final cursos = alumnosAgrupados.keys.toList()..sort();

          return ListView.builder(
            itemCount: cursos.length,
            itemBuilder: (context, index) {
              final nombreCurso = cursos[index];
              final alumnosDelCurso = alumnosAgrupados[nombreCurso]!;

              return Card(
                // Card Curso y alumno
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 2,
                child: ExpansionTile(
                  leading: const Icon(Icons.class_, color: Color(0xFF0D47A1)),
                  title: Text(
                    nombreCurso,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('${alumnosDelCurso.length} inscriptos'),
                  children: alumnosDelCurso.map((alumno) {
                    // IMPLEMENTACIÓN DEL DELETE
                    return Dismissible(
                      key: Key(alumno.id!),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        AlumnoService.instance.eliminarAlumno(alumno.id!);
                      },
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  RegistrationView(alumnoExistente: alumno),
                            ),
                          );
                        },
                        child: AlumnoCard(alumno: alumno),
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/registro'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
