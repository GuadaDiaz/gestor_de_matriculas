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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0D47A1), // Azul institucional
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0D47A1),
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),
        bottomAppBarTheme: const BottomAppBarThemeData(
          color: Color(0xFF0D47A1),
          elevation: 8,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0D47A1),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      // Definimos los idiomas soportados por nuestra aplicación
      supportedLocales: const [Locale('en', 'US'), Locale('es', 'ES')],
    );
  }
}
