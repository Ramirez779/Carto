import 'package:flutter/material.dart';
import '../main_shell.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _nameError;
  String? _emailError;
  String? _passwordError;

  bool _obscure = true;
  bool _loading = false;

  void _register() async {
    setState(() {
      _nameError = null;
      _emailError = null;
      _passwordError = null;
    });

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    bool hasError = false;

    if (name.isEmpty) {
      _nameError = 'Ingresa tu nombre';
      hasError = true;
    }

    if (email.isEmpty || !email.contains('@')) {
      _emailError = 'Correo inválido';
      hasError = true;
    }

    if (password.length < 6) {
      _passwordError = 'Mínimo 6 caracteres';
      hasError = true;
    }

    if (hasError) {
      setState(() {});
      return;
    }

    setState(() => _loading = true);

    //simulación de registro
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainShell()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEEF1F7),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 420),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.08),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xff4F6EF7).withOpacity(.15),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.person_add_alt_1_outlined,
                          color: Color(0xff4F6EF7),
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Text(
                        'Crear cuenta',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // Nombre
                  _input(
                    controller: _nameController,
                    hint: 'Nombre',
                    icon: Icons.person_outline,
                    error: _nameError,
                  ),

                  const SizedBox(height: 14),

                  // Email
                  _input(
                    controller: _emailController,
                    hint: 'Correo electrónico',
                    icon: Icons.email_outlined,
                    error: _emailError,
                  ),

                  const SizedBox(height: 14),

                  // Password
                  _passwordInput(),

                  const SizedBox(height: 22),

                  // Botón register
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff4F6EF7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      onPressed: _loading ? null : _register,
                      child: _loading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Crear cuenta',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('¿Ya tienes cuenta?'),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Inicia sesión'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //Input normal
  Widget _input({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    String? error,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 20),
            filled: true,
            fillColor: const Color(0xffF6F7FB),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        if (error != null) ...[
          const SizedBox(height: 6),
          Text(
            error,
            style: const TextStyle(
              color: Colors.redAccent,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }

  //password
  Widget _passwordInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _passwordController,
          obscureText: _obscure,
          decoration: InputDecoration(
            hintText: 'Contraseña',
            prefixIcon: const Icon(Icons.lock_outline, size: 20),
            suffixIcon: IconButton(
              icon: Icon(
                _obscure ? Icons.visibility_off : Icons.visibility,
                size: 20,
              ),
              onPressed: () {
                setState(() => _obscure = !_obscure);
              },
            ),
            filled: true,
            fillColor: const Color(0xffF6F7FB),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        if (_passwordError != null) ...[
          const SizedBox(height: 6),
          Text(
            _passwordError!,
            style: const TextStyle(
              color: Colors.redAccent,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }
}