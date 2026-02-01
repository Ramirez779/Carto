import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/order_provider.dart';
import 'order_success_screen.dart';
import '../../ui/design_tokens.dart';
import '../../models/cart_item.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool _isLoading = false;

  void _confirmOrder(BuildContext context) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final cart = context.read<CartProvider>();
      final orderProvider = context.read<OrderProvider>();

      orderProvider.addOrder(
        cart.items,
        cart.total,
      );

      cart.clear();

      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 400),
            pageBuilder: (_, __, ___) => const OrderSuccessScreen(),
            transitionsBuilder: (_, animation, __, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ),
                ),
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
          ),
        );
      }
    } catch (e) {
      debugPrint('Error al confirmar pedido: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Error al procesar el pedido'),
            backgroundColor: AppColors.danger,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.all(AppSpacing.l),
                child: Column(
                  children: [
                    // ENCABEZADO
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Icon(
                            Icons.shopping_bag_outlined,
                            size: 18,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Finaliza tu compra',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Revisa y confirma los detalles de tu pedido',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // DIRECCIÓN DE ENTREGA
                    _SectionCard(
                      title: 'Dirección de entrega',
                      icon: Icons.location_on_outlined,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Calle Principal #123',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Ciudad, País',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.edit, size: 16),
                            label: const Text('Editar dirección'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              side: BorderSide(color: AppColors.primary),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // MÉTODO DE PAGO
                    _SectionCard(
                      title: 'Método de pago',
                      icon: Icons.credit_card_outlined,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.credit_card,
                                  size: 20,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Tarjeta de crédito',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '**** **** **** 1234',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: AppColors.textSecondary,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // RESUMEN DEL PEDIDO
                    _SectionCard(
                      title: 'Resumen del pedido',
                      icon: Icons.receipt_outlined,
                      child: Column(
                        children: [
                          ...cart.items.map(
                            (item) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                children: [
                                  // IMAGEN DEL PRODUCTO
                                  Container(
                                    height: 48,
                                    width: 48,
                                    decoration: BoxDecoration(
                                      color: AppColors.background,
                                      borderRadius: BorderRadius.circular(8),
                                      image: item.product.image != null
                                          ? DecorationImage(
                                              image: NetworkImage(
                                                  item.product.image!),
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                    ),
                                    child: item.product.image == null
                                        ? Icon(
                                            Icons.shopping_bag_outlined,
                                            color: AppColors.textSecondary,
                                            size: 20,
                                          )
                                        : null,
                                  ),
                                  const SizedBox(width: 12),
                                  // DETALLES DEL PRODUCTO
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.product.title,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.textPrimary,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Cantidad: ${item.quantity}',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // PRECIO
                                  Text(
                                    '\$${(item.product.price * item.quantity).toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Divider(height: 1),
                          const SizedBox(height: 16),

                          // DESGLOSE DE PRECIOS
                          Column(
                            children: [
                              _PriceRow(
                                label: 'Subtotal',
                                value: '\$${cart.total.toStringAsFixed(2)}',
                              ),
                              const SizedBox(height: 8),
                              _PriceRow(
                                label: 'Envío',
                                value: '\$0.00',
                                valueStyle: TextStyle(
                                  color: AppColors.success,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _PriceRow(
                                label: 'Descuento',
                                value: '-\$0.00',
                                valueStyle: TextStyle(
                                  color: AppColors.danger,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Divider(height: 1),
                              const SizedBox(height: 12),
                              _PriceRow(
                                label: 'Total',
                                value: '\$${cart.total.toStringAsFixed(2)}',
                                labelStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                                valueStyle: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // BOTÓN DE CONFIRMAR
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.l,
                  AppSpacing.m,
                  AppSpacing.l,
                  AppSpacing.m + bottomInset,
                ),
                child: _AnimatedConfirmButton(
                  isLoading: _isLoading,
                  isEnabled: cart.items.isNotEmpty,
                  onPressed: () => _confirmOrder(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.l),
        border: Border.all(
          color: Colors.black.withOpacity(0.05),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  const _PriceRow({
    required this.label,
    required this.value,
    this.labelStyle,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: labelStyle ??
              TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
        ),
        Text(
          value,
          style: valueStyle ??
              TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
        ),
      ],
    );
  }
}

class _AnimatedConfirmButton extends StatefulWidget {
  final bool isLoading;
  final bool isEnabled;
  final VoidCallback onPressed;

  const _AnimatedConfirmButton({
    required this.isLoading,
    required this.isEnabled,
    required this.onPressed,
  });

  @override
  State<_AnimatedConfirmButton> createState() => _AnimatedConfirmButtonState();
}

class _AnimatedConfirmButtonState extends State<_AnimatedConfirmButton> {
  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        if (widget.isEnabled && !widget.isLoading) {
          setState(() => _isTapped = true);
        }
      },
      onTapUp: (_) => setState(() => _isTapped = false),
      onTapCancel: () => setState(() => _isTapped = false),
      onTap: widget.isEnabled && !widget.isLoading ? widget.onPressed : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 56,
        decoration: BoxDecoration(
          color: widget.isEnabled
              ? AppColors.primary
              : AppColors.primary.withOpacity(0.4),
          borderRadius: BorderRadius.circular(AppRadius.m),
          boxShadow: _isTapped
              ? []
              : [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Stack(
          children: [
            Center(
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: widget.isLoading ? 0 : 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lock_open_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Confirmar pedido',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (widget.isLoading)
              Center(
                child: SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}