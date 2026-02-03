// test/screens/checkout/checkout_header_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:carto/screens/checkout/checkout_header.dart';
import 'package:carto/ui/design_tokens.dart';

void main() {
  testWidgets('CheckoutHeader renders correctly', (WidgetTester tester) async {
    // Construye el widget
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CheckoutHeader(),
        ),
      ),
    );

    // Verifica que el título se muestre
    expect(find.text('Finaliza tu compra'), findsOneWidget);
    
    // Verifica que el subtítulo se muestre
    expect(
      find.text('Revisa y confirma los detalles de tu pedido'), 
      findsOneWidget
    );
    
    // Verifica que el ícono esté presente
    expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);
  });
}