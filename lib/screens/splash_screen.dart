import 'package:flutter/material.dart';

//Pantalla de carga inicial con animación
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  //Controlador de la animación
  late AnimationController _controller;

  //Animación de opacidad (fade in)
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    //Inicializa el controlador de animación
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    //Define la animación de aparición gradual
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    //Inicia la animación
    _controller.forward();

    //Navega a la pantalla de login después del splash
    Future.delayed(const Duration(milliseconds: 2500), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  void dispose() {
    //Libera recursos de la animación
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          //Logo con animación de aparición
          child: Image.asset(
            'assets/logo_carto.jpg',  //ruta donde se ubica el logo
            width: size.width * 0.55,
            height: size.width * 0.55,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}