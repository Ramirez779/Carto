import 'package:flutter/material.dart';
import '../main_shell.dart';
import 'login_screen.dart';
import '/widgets/auth_card.dart';

//Pantalla de registro de nuevos usuarios
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscure = true; //Controla visibilidad de contraseña
  bool _loading = false; //Estado de carga del botón
  bool _showNameError = false; //Error de nombre
  bool _showEmailError = false; //Error de email
  bool _showPasswordError = false; //Error de contraseña

  late AnimationController _controller; //Controlador de animaciones
  late Animation<double> _fade; //Animación de opacidad
  late Animation<Offset> _slide; //Animación de deslizamiento

  @override
  void initState() {
    super.initState();

    //Configuración de animaciones de entrada
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();

    //Validación en tiempo real de campos
    _nameController.addListener(_validateName);
    _emailController.addListener(_validateEmail);
    _passwordController.addListener(_validatePassword);
  }

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  //============ VALIDACIÓN ============
  bool get _isFormValid {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final pass = _passwordController.text.trim();
    final emailValid = _isValidEmail(email);
    return name.isNotEmpty && email.isNotEmpty && pass.isNotEmpty && emailValid;
  }

  //Valida formato básico de email
  bool _isValidEmail(String email) {
    return email.contains('@') && email.contains('.');
  }

  //Valida nombre en tiempo real
  void _validateName() {
    setState(() => _showNameError = _nameController.text.isEmpty);
  }

  //Valida email en tiempo real
  void _validateEmail() {
    if (_emailController.text.isEmpty) {
      setState(() => _showEmailError = false);
      return;
    }
    final isValid = _isValidEmail(_emailController.text.trim());
    setState(() => _showEmailError = !isValid);
  }

  //Valida contraseña en tiempo real (mínimo 6 caracteres)
  void _validatePassword() {
    if (_passwordController.text.isEmpty) {
      setState(() => _showPasswordError = false);
      return;
    }
    final isValid = _passwordController.text.trim().length >= 6;
    setState(() => _showPasswordError = !isValid);
  }

  //Simulación de registro de usuario
  void _registerFake() async {
    if (!_isFormValid) return;

    setState(() => _loading = true);

    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;

    //Navega a la pantalla principal limpiando el stack
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainShell()),
      (_) => false,
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
            child: FadeTransition(
              opacity: _fade,
              child: SlideTransition(
                position: _slide,
                child: AuthCard(
                  title: 'Crear cuenta',
                  children: [
                    //Campo de nombre completo
                    _input(
                      controller: _nameController,
                      hint: 'Nombre completo',
                      icon: Icons.person_outline,
                      showError: _showNameError,
                    ),
                    //Mensaje de error para nombre
                    if (_showNameError && _nameController.text.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4, left: 16),
                        child: Text(
                          'El nombre es requerido',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.red[700],
                          ),
                        ),
                      ),
                    const SizedBox(height: 10),

                    //Campo de email
                    _input(
                      controller: _emailController,
                      hint: 'Correo electrónico',
                      icon: Icons.email_outlined,
                      showError: _showEmailError,
                    ),
                    //Mensaje de error para email
                    if (_showEmailError && _emailController.text.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4, left: 16),
                        child: Text(
                          'Ingresa un email válido',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.red[700],
                          ),
                        ),
                      ),
                    const SizedBox(height: 10),

                    //Campo de contraseña
                    _passwordInput(),
                    //Mensaje de error para contraseña
                    if (_showPasswordError &&
                        _passwordController.text.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4, left: 16),
                        child: Text(
                          'Mínimo 6 caracteres',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.red[700],
                          ),
                        ),
                      ),
                    const SizedBox(height: 22),

                    //Botón principal de registro
                    _registerButton(),
                    const SizedBox(height: 20),

                    //Enlace a pantalla de login
                    _footerLogin(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //Widget reutilizable para campos de texto
  Widget _input({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool showError = false,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, size: 20),
        filled: true,
        fillColor: showError
            ? Colors.red[50]?.withOpacity(0.3)
            : const Color(0xffF6F7FB),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: showError
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.red[300]!, width: 1),
              )
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide:
                    const BorderSide(color: Color(0xffE2E6F0), width: 1),
              ),
      ),
    );
  }

  //Campo de contraseña con ícono de visibilidad
  Widget _passwordInput() {
    return TextField(
      controller: _passwordController,
      obscureText: _obscure,
      decoration: InputDecoration(
        hintText: 'Contraseña',
        prefixIcon: const Icon(Icons.lock_outline, size: 20),
        suffixIcon: IconButton(
          icon: Icon(
            _obscure ? Icons.visibility_off : Icons.visibility,
            size: 20,
            color: Colors.grey[600],
          ),
          onPressed: () {
            setState(() => _obscure = !_obscure);
          },
        ),
        filled: true,
        fillColor: _showPasswordError
            ? Colors.red[50]?.withOpacity(0.3)
            : const Color(0xffF6F7FB),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: _showPasswordError
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.red[300]!, width: 1),
              )
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide:
                    const BorderSide(color: Color(0xffE2E6F0), width: 1),
              ),
      ),
    );
  }

  //Botón principal de registro
  Widget _registerButton() {
    final isDisabled = !_isFormValid || _loading;

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isDisabled ? null : _registerFake,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff4F6EF7),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: isDisabled ? 0 : 1,
          shadowColor: const Color(0xff4F6EF7).withOpacity(0.2),
        ),
        child: _loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                'Crear cuenta',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color:
                      isDisabled ? Colors.white.withOpacity(0.8) : Colors.white,
                ),
              ),
      ),
    );
  }

  //Pie de página con enlace a login
  Widget _footerLogin() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '¿Ya tienes cuenta?',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const LoginScreen(),
              ),
            );
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          ),
          child: const Text(
            'Inicia sesión',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xff4F6EF7),
            ),
          ),
        ),
      ],
    );
  }
}