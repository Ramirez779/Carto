import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

// Pantalla de carga inicial con verificación de sesión
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Inicializa el controlador de animación
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Define la animación de aparición gradual
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // Inicia la animación
    _controller.forward();

    // Verifica la sesión después de la animación
    _checkAuthAndNavigate();
  }

  // Verifica si hay sesión activa
  Future<void> _checkAuthAndNavigate() async {
    //Cargar la sesión guardada antes de verificar
    final authProvider = context.read<AuthProvider>();
    await authProvider.initialize();
    
    // Esperar la animación
    await Future.delayed(const Duration(milliseconds: 2500));

    if (!mounted) return;

    // Si está autenticado, va al home. Si no, al login
    if (authProvider.isAuthenticated) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  void dispose() {
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
          child: Image.asset(
            'assets/logo_carto.jpg',
            width: size.width * 0.55,
            height: size.width * 0.55,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}