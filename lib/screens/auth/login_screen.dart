import 'package:flutter/material.dart';
import '../main_shell.dart';
import 'register_screen.dart';
import '/widgets/auth_card.dart';

//Pantalla de inicio de sesión
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscure = true; //Controla visibilidad de contraseña
  bool _loading = false; //Estado de carga del botón
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
    _emailController.addListener(_validateEmail);
    _passwordController.addListener(_validatePassword);
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  //============ VALIDACIÓN ============
  bool get _isFormValid {
    final email = _emailController.text.trim();
    final pass = _passwordController.text.trim();
    final emailValid = _isValidEmail(email);
    return email.isNotEmpty && pass.isNotEmpty && emailValid;
  }

  //Valida formato básico de email
  bool _isValidEmail(String email) {
    return email.contains('@') && email.contains('.');
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

  //Simulación de login con email/contraseña
  void _loginFake() async {
    if (!_isFormValid) return;

    setState(() => _loading = true);

    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;

    //Navega a la pantalla principal
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainShell()),
    );
  }

  //Simulación de login con Google
  void _loginGoogleFake() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainShell()),
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
                  title: 'Iniciar sesión',
                  children: [
                    //Campo de email con validación visual
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

                    //Campo de contraseña con toggle de visibilidad
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

                    //Botón principal de inicio de sesión
                    _loginButton(),
                    const SizedBox(height: 18),

                    //Divisor para opciones alternativas
                    _divider(),
                    const SizedBox(height: 18),

                    //Botón para login con Google
                    _googleButton(),
                    const SizedBox(height: 20),

                    //Enlace a pantalla de registro
                    _footerRegister(),
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

  //Botón principal de login
  Widget _loginButton() {
    final isDisabled = !_isFormValid || _loading;

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isDisabled ? null : _loginFake,
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
                'Iniciar sesión',
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

  //Divisor visual entre opciones de login
  Widget _divider() {
    return Row(
      children: [
        Expanded(
          child: Divider(color: Colors.grey[300], thickness: 0.8),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'o continúa con',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ),
        Expanded(
          child: Divider(color: Colors.grey[300], thickness: 0.8),
        ),
      ],
    );
  }

  //Botón para login con Google
  Widget _googleButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: _loginGoogleFake,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.grey[700],
          backgroundColor: Colors.white,
          side: BorderSide(color: Colors.grey[300]!),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Continuar con Google',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  //Pie de página con enlace a registro
  Widget _footerRegister() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '¿No tienes cuenta?',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const RegisterScreen(),
              ),
            );
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          ),
          child: const Text(
            'Regístrate',
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