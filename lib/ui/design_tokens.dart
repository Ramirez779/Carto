import 'package:flutter/material.dart';

//Colores globales de la aplicación (design tokens)
class AppColors {
  //Color principal de la marca
  static const primary = Color(0xFF4F6EF7);

  //Color de fondo general de las pantallas
  static const background = Color(0xFFF5F6FA);

  //Color base para tarjetas y superficies
  static const surface = Colors.white;
  
  //Superficies para modo oscuro/claro
  static const surfaceLight = Colors.white;
  static const surfaceDark = Color(0xFF1C1F26);

  //Color principal para textos y títulos
  static const textPrimary = Color(0xFF111111);
  
  //Texto para modo oscuro
  static const textPrimaryDark = Colors.white;

  //Color secundario para textos descriptivos
  static const textSecondary = Color(0xFF6B7280);
  
  //Texto secundario modo oscuro
  static const textSecondaryDark = Color(0xFFA0A0A0);

  //Color para estados de error o acciones destructivas
  static const danger = Color(0xFFE53935);

  //Color para estados de éxito o confirmación
  static const success = Color(0xFF4CAF50);
  
  //Colores para bordes
  static const borderLight = Color(0xFFE0E0E0);
  static const borderDark = Color(0xFF3A3F4B);
  
  //Colores para estados
  static const warning = Color(0xFFFF9800);
  static const info = Color(0xFF2196F3);
}

//Espaciados estándar para márgenes y paddings
class AppSpacing {
  //Espaciado extra pequeño
  static const xs = 4.0;

  //Espaciado pequeño
  static const s = 8.0;

  //Espaciado medio (uso más frecuente)
  static const m = 12.0;

  //Espaciado grande
  static const l = 16.0;

  //Espaciado extra grande
  static const xl = 24.0;
  
  //Espaciados adicionales
  static const xxl = 32.0;
  static const xxxl = 48.0;
}

//Radios estándar para bordes redondeados
class AppRadius {
  //Radio pequeño
  static const s = 8.0;

  //Radio medio
  static const m = 14.0;

  //Radio grande
  static const l = 20.0;
  
  //NUEVOS: Radios adicionales
  static const xs = 4.0;
  static const xl = 28.0;
  static const circle = 50.0;
}

//Para manejo de elevaciones/sombras
class AppElevation {
  static const subtle = 1.0;
  static const medium = 4.0;
  static const high = 8.0;
}