import 'package:flutter/material.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/cart/cart_screen.dart';
import '../screens/profile/profile_screen.dart';

class AppRoutes {
  static const splash = '/';
  static const home = '/home';
  static const cart = '/cart';
  static const profile = '/profile';

  static Map<String, WidgetBuilder> routes = {
    splash: (_) => const SplashScreen(),
    home: (_) =>  HomeScreen(),
    cart: (_) => const CartScreen(),
    profile: (_) => const ProfileScreen(),
  };
}
