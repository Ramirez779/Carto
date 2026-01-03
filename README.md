# Carto – Flutter Shopping App UI

Carto es un prototipo de aplicación de compras desarrollado con Flutter.
El proyecto está enfocado en la creación de una interfaz moderna, limpia
y bien estructurada para una app de e-commerce, sin integración de backend
ni servicios externos.

## Objetivo del proyecto

El objetivo principal de Carto es servir como práctica y base visual para
una aplicación de compras en línea, enfocándose en:

- Diseño de interfaces modernas con Flutter
- Organización correcta del proyecto
- Manejo de estado simple
- Experiencia de usuario clara y limpia
- Base escalable para futuras mejoras

## Tecnologías utilizadas

- Flutter (SDK 3.x)
- Dart
- Provider para manejo de estado
- Material Design
- Google Fonts

## Estructura del proyecto

lib/
├── main.dart
├── providers/
│   └── cart_provider.dart
├── screens/
│   ├── splash/
│   │   └── splash_screen.dart
│   ├── cart/
│   │   └── cart_screen.dart
│   ├── checkout/
│   │   └── checkout_screen.dart
│   └── main_shell.dart
├── models/
│   └── product.dart
└── widgets/
    └── componentes reutilizables

assets/
└── Logo_carto.png

## Funcionalidades actuales

- Pantalla splash con animación simple
- Navegación principal de la aplicación
- Listado de productos simulado
- Carrito de compras
- Eliminación de productos del carrito
- Cálculo automático del total
- Pantalla de resumen previa al pago

## Alcance del proyecto

Este proyecto es únicamente una demostración de interfaz y estructura.
No incluye:

- Backend
- Autenticación
- Pagos reales
- Base de datos

Todo el contenido es simulado con fines educativos.

## Autor

Proyecto desarrollado como práctica personal en Flutter.