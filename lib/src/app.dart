import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gestion_de_matriculas/src/routes/routes.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gestión Matrículas',
      initialRoute: '/',
      routes: getRoutes(),
      localizationsDelegates: const [
        // Delegados
        GlobalMaterialLocalizations
            .delegate, // Traduce componentes Material (ej. Calendarios)
        GlobalWidgetsLocalizations
            .delegate, // Traduce la dirección del texto (ej. de Izq a Der)
        GlobalCupertinoLocalizations.delegate, // Traduce componentes estilo iOS
      ],

      // Definimos los idiomas soportados por nuestra aplicación
      supportedLocales: const [Locale('en', 'US'), Locale('es', 'ES')],
    );
  }
}
