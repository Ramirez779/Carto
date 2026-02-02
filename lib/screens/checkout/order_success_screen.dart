import 'package:flutter/material.dart';
import '../../ui/design_tokens.dart';

//Pantalla de confirmación de pedido exitoso
class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Animación de éxito
              _EnhancedSuccessAnimation(),

              SizedBox(height: AppSpacing.xl),

              //Título con efecto gradiente
              ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    colors: [
                      AppColors.primary,
                      Color(0xFF6C8AFF),
                    ],
                  ).createShader(bounds);
                },
                child: Text(
                  '¡Pedido confirmado!',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),

              SizedBox(height: AppSpacing.m),

              //Mensaje principal
              Text(
                'Tu compra se procesó exitosamente',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),

              SizedBox(height: AppSpacing.s),

              //Mensaje secundario
              Text(
                'Recibirás un correo de confirmación pronto',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),

              SizedBox(height: AppSpacing.xl * 2),

              //Botón principal: volver al inicio
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.m),
                    ),
                    elevation: 2,
                    shadowColor: AppColors.primary.withOpacity(0.3),
                  ),
                  onPressed: () {
                    //Regresa a la primera pantalla del stack
                    Navigator.popUntil(
                      context,
                      (route) => route.isFirst,
                    );
                  },
                  icon: const Icon(Icons.home_outlined, size: 20),
                  label: Text(
                    'Volver al inicio',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              SizedBox(height: AppSpacing.l),

              //Acción secundaria (futuro: pedidos)
              TextButton(
                onPressed: () {
                  //Navegar a pedidos en el futuro
                },
                child: Text(
                  'Ver mis pedidos',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//Animación personalizada de éxito
class _EnhancedSuccessAnimation extends StatefulWidget {
  @override
  State<_EnhancedSuccessAnimation> createState() =>
      _EnhancedSuccessAnimationState();
}

class _EnhancedSuccessAnimationState extends State<_EnhancedSuccessAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _bounceAnimation;
  late Animation<double> _circlePulseAnimation;

  @override
  void initState() {
    super.initState();

    //Controlador principal de la animación
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    //Escala inicial del icono
    _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.4, curve: Curves.easeOutBack),
      ),
    );

    //Efecto rebote
    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.15), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.15, end: 1.0), weight: 50),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.8, curve: Curves.easeInOut),
      ),
    );

    //Pulso circular exterior
    _circlePulseAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 50),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            //Círculo de pulso
            if (_circlePulseAnimation.value > 0)
              Container(
                height: 160 * _circlePulseAnimation.value,
                width: 160 * _circlePulseAnimation.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withOpacity(
                    0.1 * _circlePulseAnimation.value,
                  ),
                ),
              ),

            //Icono principal con gradiente
            Transform.scale(
              scale: _scaleAnimation.value * _bounceAnimation.value,
              child: Container(
                height: 140,
                width: 140,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      Color(0xFF6C8AFF),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.check_rounded,
                  size: 64,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}