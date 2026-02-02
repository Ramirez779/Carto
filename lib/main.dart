// Importa los widgets base de Flutter
import 'package:flutter/material.dart';

// Importa Provider para la gestión de estado
import 'package:provider/provider.dart';

// Importa el proveedor del carrito
import 'providers/cart_provider.dart';

// Importa el widget principal de la aplicación
import 'app.dart';

// Punto de entrada principal de la aplicación
void main() {
  // Inicia la app ejecutando el widget raíz
  runApp(const CartoApp());
}