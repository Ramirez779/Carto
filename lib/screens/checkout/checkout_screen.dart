import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cart_provider.dart';
import '../../providers/order_provider.dart';
import '../../ui/design_tokens.dart';

import 'checkout_header.dart';
import 'address_section.dart';
import 'payment_section.dart';
import 'order_summary_section.dart';
import 'confirm_button.dart';
import 'order_success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool _isLoading = false;

  Future<void> _confirmOrder() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final cart = context.read<CartProvider>();
      final orders = context.read<OrderProvider>();

      orders.addOrder(cart.items, cart.total);
      cart.clear();

      await Future.delayed(const Duration(milliseconds: 400));

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const OrderSuccessScreen(),
        ),
      );
    } catch (e) {
      debugPrint('Error al confirmar pedido: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Error al procesar el pedido'),
          backgroundColor: AppColors.danger,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final bottomInset = MediaQuery.of(context).viewPadding.bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      // AppBar simplificado sin título, solo botón de retroceso
      appBar: AppBar(
        title: const SizedBox.shrink(), // Título vacío
        centerTitle: false,
        elevation: 0,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        automaticallyImplyLeading:
            true, // Muestra automáticamente el botón de retroceso
      ),
      body: SafeArea(
        child: Column(
          children: [
            // CONTENIDO PRINCIPAL
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    CheckoutHeader(),
                    SizedBox(
                        height: 28), // Espaciado aumentado para mejor jerarquía
                    AddressSection(),
                    SizedBox(height: 16),
                    PaymentSection(),
                    SizedBox(height: 16),
                    OrderSummarySection(),
                  ],
                ),
              ),
            ),

            // BOTÓN INFERIOR
            Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                16,
                20,
                16 + bottomInset,
              ),
              child: ConfirmButton(
                isLoading: _isLoading,
                isEnabled: cart.items.isNotEmpty,
                onPressed: _confirmOrder,
              ),
            ),
          ],
        ),
      ),
    );
  }
}