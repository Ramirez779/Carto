import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../checkout/checkout_screen.dart';
import '../../ui/design_tokens.dart';
import '../../models/cart_item.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                  AppSpacing.l, AppSpacing.xl, AppSpacing.l, 0),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                      color: AppColors.textPrimary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Carrito',
                      style: GoogleFonts.inter(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            cart.items.isEmpty
                ? const SliverFillRemaining(
                    hasScrollBody: false,
                    child: _EmptyCartView(),
                  )
                : SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.l),
                    sliver: SliverList.separated(
                      itemCount: cart.items.length,
                      separatorBuilder: (_, __) =>
                          SizedBox(height: AppSpacing.m),
                      itemBuilder: (context, index) {
                        final item = cart.items[index];

                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (child, animation) {
                            return FadeTransition(
                              opacity: CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeInOut,
                              ),
                              child: SizeTransition(
                                sizeFactor: animation,
                                child: child,
                              ),
                            );
                          },
                          child: _buildCartItem(item, cart,
                              key: ValueKey(item.product.id)),
                        );
                      },
                    ),
                  ),
            const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        ),
      ),
      bottomNavigationBar: cart.items.isEmpty
          ? null
          : SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    AppSpacing.l, AppSpacing.m, AppSpacing.l, AppSpacing.m),
                child: Container(
                  padding: EdgeInsets.all(AppSpacing.l),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.l),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Subtotal',
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            '\$${cart.total.toStringAsFixed(2)}',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Envío',
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            '\$0.00',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24, thickness: 1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            '\$${cart.total.toStringAsFixed(2)}',
                            style: GoogleFonts.inter(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSpacing.m),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppRadius.m),
                            ),
                            elevation: 2,
                            shadowColor: AppColors.primary.withOpacity(0.3),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CheckoutScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.arrow_forward_rounded,
                              size: 20),
                          label: Text(
                            'Proceder al pago',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildCartItem(CartItem item, CartProvider cart, {required Key key}) {
    return Container(
      key: key,
      padding: EdgeInsets.all(AppSpacing.m),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.l),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // IMAGEN DEL PRODUCTO CON BADGE
          Stack(
            children: [
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(AppRadius.m),
                  image: item.product.image != null
                      ? DecorationImage(
                          image: NetworkImage(item.product.image!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: item.product.image == null
                    ? Icon(
                        Icons.shopping_bag_outlined,
                        color: AppColors.textSecondary,
                        size: 28,
                      )
                    : null,
              ),
              if (item.quantity > 1)
                Positioned(
                  top: -6,
                  right: -6,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      '${item.quantity}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(width: AppSpacing.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  '\$${item.product.price.toStringAsFixed(2)}',
                  style: GoogleFonts.inter(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  'Cantidad: ${item.quantity}',
                  style: GoogleFonts.inter(
                    color: AppColors.textSecondary.withOpacity(0.7),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          _AnimatedDeleteButton(
            onPressed: () => cart.removeProduct(item.product),
          ),
        ],
      ),
    );
  }
}

class _AnimatedDeleteButton extends StatefulWidget {
  final VoidCallback onPressed;

  const _AnimatedDeleteButton({required this.onPressed});

  @override
  State<_AnimatedDeleteButton> createState() => _AnimatedDeleteButtonState();
}

class _AnimatedDeleteButtonState extends State<_AnimatedDeleteButton> {
  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isTapped = true),
      onTapUp: (_) => setState(() => _isTapped = false),
      onTapCancel: () => setState(() => _isTapped = false),
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: _isTapped
              ? AppColors.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          Icons.delete_outline,
          color: _isTapped ? AppColors.primary : AppColors.textSecondary,
          size: 22,
        ),
      ),
    );
  }
}

class _EmptyCartView extends StatelessWidget {
  const _EmptyCartView();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shopping_bag_outlined,
              size: 60,
              color: AppColors.primary.withOpacity(0.4),
            ),
          ),
          SizedBox(height: AppSpacing.xl),
          Text(
            'Tu carrito está vacío',
            style: GoogleFonts.inter(
              fontSize: 20,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: AppSpacing.s),
          Text(
            'Agrega productos desde la página de inicio para continuar',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 15,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          SizedBox(height: AppSpacing.xl),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.m),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.home_outlined, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Ir a inicio',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}