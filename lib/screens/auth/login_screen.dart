import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import '../main_shell.dart';
import 'register_screen.dart';
import '/widgets/auth_card.dart';
import '../../providers/auth_provider.dart'; 

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscure = true;
  bool _loading = false;
  bool _showEmailError = false;
  bool _showPasswordError = false;

  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    // Animación de entrada suave 
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.03),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _controller.forward();

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

  //validción

  bool get _isFormValid {
    final email = _emailController.text.trim();
    final pass = _passwordController.text.trim();
    final emailValid = _isValidEmail(email);
    return email.isNotEmpty && pass.isNotEmpty && emailValid;
  }

  // Nivel de completitud del formulario (0.0 a 1.0)
  double get _formCompleteness {
    int completed = 0;
    if (_emailController.text.isNotEmpty && !_showEmailError) completed++;
    if (_passwordController.text.isNotEmpty && !_showPasswordError) completed++;
    return completed / 2;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void _validateEmail() {
    if (_emailController.text.isEmpty) {
      setState(() => _showEmailError = false);
      return;
    }
    final isValid = _isValidEmail(_emailController.text.trim());
    setState(() => _showEmailError = !isValid);
  }

  void _validatePassword() {
    if (_passwordController.text.isEmpty) {
      setState(() => _showPasswordError = false);
      return;
    }
    final isValid = _passwordController.text.trim().length >= 6;
    setState(() => _showPasswordError = !isValid);
  }

  // Obtener nivel de seguridad de contraseña
  String get _passwordStrength {
    final pass = _passwordController.text;
    if (pass.length < 6) return 'Débil';
    if (pass.length < 8) return 'Media';
    if (pass.length >= 8 && RegExp(r'[0-9]').hasMatch(pass)) return 'Fuerte';
    return 'Media';
  }

  Color get _passwordStrengthColor {
    switch (_passwordStrength) {
      case 'Débil':
        return Colors.red;
      case 'Media':
        return Colors.orange;
      case 'Fuerte':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  //acciones
  void _loginFake() async {
    if (!_isFormValid) return;

    setState(() => _loading = true);

    //Intenta login real con AuthProvider
    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    setState(() => _loading = false);

    if (success) {
      // Login exitoso
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainShell()),
      );
    } else {
      // Muestra error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage ?? 'Error al iniciar sesión'),
          backgroundColor: Colors.red[700],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  void _loginGoogleFake() {
    //No hace nada por ahora
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Inicio de sesión con Google no disponible'),
        backgroundColor: Colors.orange[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEEF1F7),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: FadeTransition(
              opacity: _fade,
              child: SlideTransition(
                position: _slide,
                child: Container(
                  // Sombra sutil para efecto de profundidad
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 24,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Título con mejor jerarquía tipográfica
                      const Text(
                        'Iniciar sesión',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff1A1D2E),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Subtítulo descriptivo
                      Text(
                        'Ingresa tus credenciales para continuar',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Campo de email
                      _input(
                        controller: _emailController,
                        hint: 'Correo electrónico',
                        icon: Icons.email_outlined,
                        showError: _showEmailError,
                        keyboardType: TextInputType.emailAddress,
                      ),

                      // Mensaje de error email
                      if (_showEmailError && _emailController.text.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 6, left: 4),
                          child: Row(
                            children: [
                              Icon(Icons.error_outline,
                                  size: 14, color: Colors.red[700]),
                              const SizedBox(width: 4),
                              Text(
                                'Ingresa un email válido',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.red[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 14),

                      // Campo de contraseña
                      _passwordInput(),

                      // Mensaje de error contraseña
                      if (_showPasswordError &&
                          _passwordController.text.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 6, left: 4),
                          child: Row(
                            children: [
                              Icon(Icons.error_outline,
                                  size: 14, color: Colors.red[700]),
                              const SizedBox(width: 4),
                              Text(
                                'Mínimo 6 caracteres',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.red[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Indicador de fortaleza de contraseña
                      if (_passwordController.text.isNotEmpty &&
                          !_showPasswordError)
                        Padding(
                          padding: const EdgeInsets.only(top: 8, left: 4),
                          child: Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: _passwordStrengthColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Seguridad: $_passwordStrength',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: _passwordStrengthColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 20),

                      // Barra de progreso de completado
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: _formCompleteness,
                          minHeight: 4,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _formCompleteness < 1
                                ? Colors.orange[400]!
                                : Colors.green[400]!,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Botón de login
                      _loginButton(),

                      const SizedBox(height: 20),

                      // Divisor con texto
                      _divider(),

                      const SizedBox(height: 20),

                      // Botón de Google
                      _googleButton(),

                      const SizedBox(height: 20),

                      // Footer con enlace a registro
                      _footerRegister(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _input({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool showError = false,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.grey[400],
          fontSize: 15,
        ),
        prefixIcon: Icon(
          icon,
          size: 20,
          color: showError ? Colors.red[400] : Colors.grey[600],
        ),
        filled: true,
        fillColor: showError
            ? Colors.red[50]?.withOpacity(0.4)
            : const Color(0xffF6F7FB),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: showError ? Colors.red[300]! : const Color(0xffE2E6F0),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: showError ? Colors.red[400]! : const Color(0xff4F6EF7),
            width: 2,
          ),
        ),
      ),
    );
  }

  Widget _passwordInput() {
    return TextField(
      controller: _passwordController,
      obscureText: _obscure,
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        hintText: 'Contraseña',
        hintStyle: TextStyle(
          color: Colors.grey[400],
          fontSize: 15,
        ),
        prefixIcon: Icon(
          Icons.lock_outline,
          size: 20,
          color: _showPasswordError ? Colors.red[400] : Colors.grey[600],
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscure ? Icons.visibility_off : Icons.visibility,
            size: 22, // Aumentado para mejor Ley de Fitts
            color: Colors.grey[600],
          ),
          padding: const EdgeInsets.all(12), // Área táctil más grande
          onPressed: () {
            setState(() => _obscure = !_obscure);
          },
        ),
        filled: true,
        fillColor: _showPasswordError
            ? Colors.red[50]?.withOpacity(0.4)
            : const Color(0xffF6F7FB),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color:
                _showPasswordError ? Colors.red[300]! : const Color(0xffE2E6F0),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color:
                _showPasswordError ? Colors.red[400]! : const Color(0xff4F6EF7),
            width: 2,
          ),
        ),
      ),
    );
  }

  Widget _loginButton() {
    final isDisabled = !_isFormValid || _loading;

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isDisabled ? null : _loginFake,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDisabled
              ? const Color(0xffC5D0F7)
              : const Color(0xff4F6EF7),
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xffC5D0F7),
          disabledForegroundColor: Colors.white.withOpacity(0.7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: isDisabled ? 0 : 2,
          shadowColor: const Color(0xff4F6EF7).withOpacity(0.3),
        ),
        child: _loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : const Text(
                'Iniciar sesión',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
      ),
    );
  }

  Widget _divider() {
    return Row(
      children: [
        Expanded(
          child: Divider(color: Colors.grey[300], thickness: 0.8),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'o continúa con',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Divider(color: Colors.grey[300], thickness: 0.8),
        ),
      ],
    );
  }

  Widget _googleButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: _loginGoogleFake,
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xff1A1D2E),
          backgroundColor: Colors.white,
          side: BorderSide(color: Colors.grey[300]!, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
        icon: Image.network(
          'https://www.google.com/favicon.ico', //Icono Google
          width: 20,
          height: 20,
          errorBuilder: (context, error, stackTrace) => const Icon(
            Icons.g_mobiledata,
            size: 24,
          ),
        ),
        label: const Text(
          'Continuar con Google',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }

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
            minimumSize: const Size(44, 44), // Ley de Fitts
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