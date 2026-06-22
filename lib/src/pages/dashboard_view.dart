import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:gestion_de_matriculas/src/alumno/alumno_model.dart';
import 'dart:convert';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  List<Alumno> alumnos = [];
  bool isLoading = true; // Fundamental para evitar null-safety crashes

  @override
  void initState() {
    super.initState();
    _cargarAlumnosDesdeJson();
  }

  // Carga de los alumnos
  Future<void> _cargarAlumnosDesdeJson() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'data/alumnos.json',
      );

      // Deserialización
      final List<dynamic> jsonList = jsonDecode(jsonString);

      setState(() {
        alumnos = jsonList
            .map((item) => Alumno(nombre: item['nombre'], curso: item['curso']))
            .toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint("Error loading JSON: $e");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard de Matrícula')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: alumnos.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(alumnos[index].nombre),
                    subtitle: Text(alumnos[index].curso),
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
