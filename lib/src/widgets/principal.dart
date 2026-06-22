import 'package:flutter/material.dart';
import 'dart:async';

class Principal extends StatefulWidget {
  const Principal({super.key});

  @override
  State<Principal> createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {

  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;

  
  final List<String> _imagenes = [
    'assets/ECLGSM_frente.jpg',
    'assets/industriaal.jpg', 
    'assets/EscDec.jpg', // 
  ];

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_currentPage < _imagenes.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0; 
      }

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _imagenes.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              return Image.asset(
                _imagenes[index],
                fit: BoxFit.cover,
              );
            },
          ),
        ),
    
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black.withValues(alpha: 0.4),
        ),
        
        Center(
          child: Padding(
        
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: const Text(
              'Escuela de Comercio Libertador General San Martín',
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
        ),
      ],
    );
  }
}
