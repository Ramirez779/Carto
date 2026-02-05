import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Design Tokens (colores, radios, estilos globales)
import 'ui/design_tokens.dart';

// Screens
import 'screens/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/main_shell.dart';
import 'screens/checkout/order_success_screen.dart';

// Providers (estado global de la app)
import 'providers/cart_provider.dart';
import 'providers/order_provider.dart';
import 'providers/profile_provider.dart';
import 'providers/product_provider.dart'; 

// Fuente personalizada
import 'package:google_fonts/google_fonts.dart';

class CartoApp extends StatelessWidget {
  const CartoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // Registro de providers globales
      providers: [
        ChangeNotifierProvider(
          // Proveedor del carrito con carga inicial
          create: (_) => CartProvider()..loadCart(),
        ),
        // Proveedor de órdenes
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        // Proveedor de perfil de usuario
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        // Provider de productos
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: MaterialApp(
        // Oculta la etiqueta de debug
        debugShowCheckedModeBanner: false,

        // Tema global de la aplicación
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.background,
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            brightness: Brightness.light,
          ),

          // Tipografía global
          textTheme: GoogleFonts.interTextTheme().apply(
            bodyColor: AppColors.textPrimary,
            displayColor: AppColors.textPrimary,
          ),

          // Estilo global de botones elevados
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.m),
              ),
              elevation: 0,
            ),
          ),
        ),

        // Ruta inicial de la app
        initialRoute: '/splash',

        // Definición de rutas
        routes: {
          '/splash': (context) => const SplashScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/home': (context) => const MainShell(),
          '/order-success': (context) => const OrderSuccessScreen(),
        },
      ),
    );
  }
}