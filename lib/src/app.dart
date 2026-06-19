import 'package:flutter/material.dart';
import 'package:mi_app/src/widgets/formulario_login.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: DefaultTabController(
        length: 4,
        initialIndex: 0,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF0D47A1),
            toolbarHeight: 0,
            bottom: const TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white54,
              indicatorColor: Colors.white,
              labelPadding: EdgeInsets.symmetric(horizontal: 5),
              tabs: [
                Tab(icon: Icon(Icons.school), text: 'Principal'),
                Tab(icon: Icon(Icons.login), text: 'Inicio'),
                Tab(icon: Icon(Icons.newspaper), text: 'Novedades'),
                Tab(icon: Icon(Icons.calendar_month), text: 'Ciclo'),
              ],
            ),
          ),

          body: TabBarView(
            children: [
              // --- PANTALLA 1: PRINCIPAL ---
              Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: Image.asset('assets/escuela.jpg', fit: BoxFit.cover),
                  ),
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.black.withValues(alpha: 0.4),
                  ),
                  Center(
                    child: const Text(
                      'COLEGIO SAN JUAN',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black,
                            offset: Offset(2.0, 2.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // --- PANTALLA 2: INICIO (Formulario de Login) ---
              const FormularioLogin(),

              // --- PANTALLA 3: NOVEDADES (Modificada para usar Image.asset) ---
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Últimas noticias',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Cambiado de Image.network a Image.asset:
                    Image.asset(
                      'assets/novedades.png',
                      height: 400,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),

              // --- PANTALLA 4: CICLO LECTIVO ---
              Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Calendario Académico',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0D47A1),
                        ),
                      ),
                      const SizedBox(height: 10),
                      CalendarDatePicker(
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2024),
                        lastDate: DateTime(2030),
                        onDateChanged: (DateTime fechaSeleccionada) {
                          debugPrint(
                            'El usuario tocó la fecha: $fechaSeleccionada',
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // --- REDES SOCIALES FIJAS ABAJO ---
          bottomNavigationBar: BottomAppBar(
            color: const Color(0xFF0D47A1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(
                    Icons.facebook,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.chat, color: Colors.white, size: 30),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
