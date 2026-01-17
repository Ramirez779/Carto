import 'package:flutter/material.dart';
import '../main_shell.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // Icono superior
              Center(
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: const Color(0xff4F6EF7).withOpacity(.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.person_add_alt_1_outlined,
                    size: 34,
                    color: Color(0xff4F6EF7),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              const Text(
                'Crear cuenta',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Regístrate para comenzar',
                style: TextStyle(color: Colors.black54),
              ),

              const SizedBox(height: 32),

              // Nombre
              _input(
                label: 'Nombre',
                hint: 'Tu nombre',
                icon: Icons.person_outline,
              ),

              const SizedBox(height: 16),

              // Email
              _input(
                label: 'Correo electrónico',
                hint: 'example@email.com',
                icon: Icons.email_outlined,
              ),

              const SizedBox(height: 16),

              // Password
              _input(
                label: 'Contraseña',
                hint: '••••••••',
                icon: Icons.lock_outline,
                obscure: true,
              ),

              const SizedBox(height: 24),

              // Botón register
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff4F6EF7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MainShell(),
                      ),
                      (route) => false,
                    );
                  },
                  child: const Text(
                    'Crear cuenta',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('¿Ya tienes cuenta?'),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Inicia sesión'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Input reutilizable
  Widget _input({
    required String label,
    required String hint,
    required IconData icon,
    bool obscure = false,
  }) {
    return TextField(
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
