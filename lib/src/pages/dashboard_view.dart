import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:gestion_de_matriculas/src/alumno/alumno_model.dart';
import 'package:gestion_de_matriculas/src/widgets/alumno_card.dart';
import 'dart:convert';
// Tu nuevo componente separado

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  List<Alumno> alumnos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarAlumnosDesdeJson();
  }

  Future<void> _cargarAlumnosDesdeJson() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/alumnos.json',
      );
      final List<dynamic> jsonList = jsonDecode(jsonString);

      setState(() {
        alumnos = jsonList
            .map(
              (item) => Alumno(
                nombre: item['nombre'],
                curso: item['curso'],
                dni: item['dni'] ?? 'Sin DNI',
                fechaNacimiento: item['fechaNacimiento'] != null
                    ? DateTime.parse(item['fechaNacimiento'])
                    : DateTime.now(),
              ),
            )
            .toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint("Error: $e");
    }
  }

  Future<void> _navigateAndAddAlumno(BuildContext context) async {
    final result = await Navigator.pushNamed(context, '/registro');

    if (result != null && result is Alumno) {
      setState(() {
        alumnos.add(result);
      });
    }
  }

  // --- ALGORITHMIC GROUPING LOGIC ---
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
    // Transform the data before rendering
    final alumnosAgrupados = _agruparPorCurso(alumnos);
    // Extract the keys (courses) to build our main list
    final cursos = alumnosAgrupados.keys.toList();
    // Sort courses alphabetically for a professional UX
    cursos.sort();

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard de Matrícula')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : alumnos.isEmpty
          ? const Center(child: Text("No hay alumnos registrados."))
          : ListView.builder(
              itemCount: cursos.length,
              itemBuilder: (context, index) {
                final nombreCurso = cursos[index];
                final alumnosDelCurso = alumnosAgrupados[nombreCurso]!;

                // Requirement: The native Accordion pattern
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  elevation: 2,
                  child: ExpansionTile(
                    leading: const Icon(Icons.class_, color: Color(0xFF0D47A1)),
                    title: Text(
                      nombreCurso,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text('${alumnosDelCurso.length} inscriptos'),
                    children: alumnosDelCurso.map((alumno) {
                      // Reusing your decoupled AlumnoCard
                      return AlumnoCard(alumno: alumno);
                    }).toList(),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateAndAddAlumno(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
