import 'package:flutter/material.dart';
import 'package:gestion_de_matriculas/src/pages/home_page.dart';
import 'package:gestion_de_matriculas/src/pages/login.dart'; // Ajusta tus imports
import 'package:gestion_de_matriculas/src/pages/docente.dart';
import 'package:gestion_de_matriculas/src/pages/dashboard_view.dart';
import 'package:gestion_de_matriculas/src/pages/registration_view.dart';

// The Route Map
// Nota: PantallaAlumno no está aquí porque requiere alumnoId como parámetro.
// Se navega a ella desde el login con Navigator.pushReplacement + alumnoId.
Map<String, WidgetBuilder> getRoutes() {
  return {
    '/': (context) => const HomePage(),
    '/login': (context) => const FormularioLogin(),
    '/docente': (context) => const PantallaDocente(),
    '/dashboard': (context) => const DashboardView(),
    '/registro': (context) => const RegistrationView(),
  };
}
