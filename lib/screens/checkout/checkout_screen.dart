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

  //Confirma el pedido, lo guarda y navega a la pantalla de éxito
  Future<void> _confirmOrder() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final cart = context.read<CartProvider>();
      final orders = context.read<OrderProvider>();

      //Guarda el pedido
      orders.addOrder(cart.items, cart.total);

      //Limpia el carrito
      cart.clear();

      //Pequeño delay para feedback visual
      await Future.delayed(const Duration(milliseconds: 400));

      if (!mounted) return;

      //Navega a la pantalla de éxito
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
      appBar: AppBar(
        title: const Text('Checkout'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SafeArea(
        child: Column(
          children: [
            //CONTENIDO PRINCIPAL
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppSpacing.l),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    CheckoutHeader(),
                    SizedBox(height: 32),
                    AddressSection(),
                    SizedBox(height: 16),
                    PaymentSection(),
                    SizedBox(height: 16),
                    OrderSummarySection(),
                  ],
                ),
              ),
            ),

            //BOTÓN INFERIOR
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.l,
                AppSpacing.m,
                AppSpacing.l,
                AppSpacing.m + bottomInset,
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