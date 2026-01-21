import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Screens
import 'screens/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/main_shell.dart';
import 'screens/checkout/order_success_screen.dart';

// Providers
import 'providers/cart_provider.dart';
import 'providers/order_provider.dart';

//fonts
import 'package:google_fonts/google_fonts.dart';

class CartoApp extends StatelessWidget {
  const CartoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CartProvider()..loadCart(),
        ),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        theme: ThemeData(
          textTheme: GoogleFonts.interTextTheme(), // Tipografía Inter
          scaffoldBackgroundColor: const Color(0xffF5F6FA),
          useMaterial3: true, // Material Design 3
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xff4F6EF7), // Color principal
            brightness: Brightness.light,
          ),
        ),

        //pantalla inicial
        initialRoute: '/splash',

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
