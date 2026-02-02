// Prueba básica de widget en Flutter
// 
// Para realizar interacciones con un widget en tu prueba, usa la utilidad
// WidgetTester del paquete flutter_test. Por ejemplo, puedes enviar gestos
// de toque y desplazamiento. También puedes usar WidgetTester para encontrar
// widgets hijos en el árbol de widgets, leer texto y verificar que los valores
// de las propiedades de los widgets sean correctos.

import 'package:carto/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:carto/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Construye nuestra aplicación y desencadena un frame.
    await tester.pumpWidget(const CartoApp());

    // Verifica que nuestro contador comience en 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Toca el ícono '+' y desencadena un frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verifica que nuestro contador se haya incrementado.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}