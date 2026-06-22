import 'package:flutter/material.dart';

class Novedades extends StatelessWidget {
  const Novedades({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Últimas noticias',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          Image.asset('assets/novedades.png', height: 400, fit: BoxFit.cover),
        ],
      ),
    );
  }
}
