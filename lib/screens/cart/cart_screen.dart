//Imports
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../checkout/checkout_screen.dart';
import '../../ui/design_tokens.dart';
import '../../models/cart_item.dart';

//Pantalla principal del carrito de compras
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
            //Encabezado con botón de retroceso y título
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                  AppSpacing.l, AppSpacing.xl, AppSpacing.l, 0),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_rounded),
                      onPressed: () {
                        // Si podemos hacer pop, lo hacemos. Si no, vamos al home
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        } else {
                          Navigator.pushReplacementNamed(context, '/home');
                        }
                      },
                      color: AppColors.textPrimary,
                      iconSize: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Carrito',
                      style: GoogleFonts.inter(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
            //Contenido condicional: vacío o con productos
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
      //Barra inferior con resumen y botón de pago esto solo si hay productos
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
                    border: Border.all(
                      color: Colors.black.withOpacity(0.06),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //Fila de subtotal
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Subtotal',
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                              letterSpacing: -0.1,
                            ),
                          ),
                          Text(
                            '\$${cart.total.toStringAsFixed(2)}',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      //Fila de costo de envío
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Envío',
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                              letterSpacing: -0.1,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Gratis',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.green.shade700,
                                letterSpacing: -0.1,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Divider(
                          height: 1,
                          thickness: 1,
                          color: Colors.black.withOpacity(0.06),
                        ),
                      ),
                      //Fila de total general
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                              letterSpacing: -0.3,
                            ),
                          ),
                          Text(
                            '\$${cart.total.toStringAsFixed(2)}',
                            style: GoogleFonts.inter(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSpacing.l),
                      //Botón para proceder al pago
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppRadius.m),
                            ),
                            elevation: 0,
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Proceder al pago',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.2,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_forward_rounded,
                                size: 20,
                              ),
                            ],
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

  //Construye un widget para cada item del carrito
  Widget _buildCartItem(CartItem item, CartProvider cart, {required Key key}) {
    return Container(
      key: key,
      padding: EdgeInsets.all(AppSpacing.m),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.l),
        border: Border.all(
          color: Colors.black.withOpacity(0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          //Contenedor de imagen del producto con badge de cantidad
          Stack(
            children: [
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(AppRadius.m),
                  border: Border.all(
                    color: Colors.black.withOpacity(0.05),
                  ),
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
                        color: AppColors.textSecondary.withOpacity(0.5),
                        size: 32,
                      )
                    : null,
              ),
              //Badge que muestra cantidad si es mayor a 1
              if (item.quantity > 1)
                Positioned(
                  top: -6,
                  right: -6,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.surface,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      '${item.quantity}',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        height: 1,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(width: AppSpacing.m),
          //Detalles del producto
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.2,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Text(
                      '\$${item.product.price.toStringAsFixed(2)}',
                      style: GoogleFonts.inter(
                        color: AppColors.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '× ${item.quantity}',
                      style: GoogleFonts.inter(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  'Total: \$${(item.product.price * item.quantity).toStringAsFixed(2)}',
                  style: GoogleFonts.inter(
                    color: AppColors.textSecondary.withOpacity(0.8),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.1,
                  ),
                ),
              ],
            ),
          ),
          //Botón para eliminar producto
          _AnimatedDeleteButton(
            onPressed: () => cart.removeProduct(item.product),
          ),
        ],
      ),
    );
  }
}

//Botón animado para eliminar items del carrito
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
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: _isTapped
              ? AppColors.danger.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _isTapped
                ? AppColors.danger.withOpacity(0.2)
                : Colors.transparent,
          ),
        ),
        child: Icon(
          Icons.delete_outline_rounded,
          color: _isTapped ? AppColors.danger : AppColors.textSecondary,
          size: 22,
        ),
      ),
    );
  }
}

//Vista que se muestra cuando el carrito está vacío
class _EmptyCartView extends StatelessWidget {
  const _EmptyCartView();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Icono de carrito vacío
          Container(
            height: 140,
            width: 140,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  AppColors.primary.withOpacity(0.15),
                  AppColors.primary.withOpacity(0.05),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shopping_bag_outlined,
              size: 70,
              color: AppColors.primary.withOpacity(0.5),
            ),
          ),
          SizedBox(height: AppSpacing.xl),
          //Mensaje principal
          Text(
            'Tu carrito está vacío',
            style: GoogleFonts.inter(
              fontSize: 24,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: AppSpacing.m),
          //Instrucciones
          Text(
            'Agrega productos desde la página de inicio para continuar',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 15,
              color: AppColors.textSecondary,
              height: 1.5,
              letterSpacing: -0.1,
            ),
          ),
          SizedBox(height: AppSpacing.xl),
          //Botón para ir al inicio
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/home',
                  (route) => false,
                );
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
                  const Icon(Icons.home_outlined, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    'Ir a inicio',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
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