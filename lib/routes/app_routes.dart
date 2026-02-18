// lib/routes/app_routes.dart
import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/cart/cart_screen.dart';
import '../screens/profile/profile_screen.dart';

//Definición centralizada de rutas de la aplicación
class AppRoutes {
  //Nombres de rutas
  static const splash = '/';
  static const home = '/home';
  static const cart = '/cart';
  static const profile = '/profile';

  //Mapa de rutas para MaterialApp
  static Map<String, WidgetBuilder> routes = {
    //Pantalla de carga inicial
    splash: (_) => const SplashScreen(),

    //Pantalla principal
    home: (_) => const HomeScreen(),

    //Pantalla del carrito
    cart: (_) => const CartScreen(),

    //Pantalla de perfil del usuario
    profile: (_) => const ProfileScreen(),
  };
}