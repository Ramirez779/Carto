import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:carto/models/product.dart';
import 'package:carto/providers/product_provider.dart';
import 'package:carto/screens/product/product_detail_screen.dart';
import 'package:carto/widgets/home_sliver_app.dart';
import 'package:carto/widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _initialLoading = true;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();

    // Cargar productos iniciales
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialProducts();
    });

    // Timer para carga inicial visual
    Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() => _initialLoading = false);
      }
    });
  }

  Future<void> _loadInitialProducts() async {
    try {
      await context.read<ProductProvider>().loadProducts();
    } catch (e) {
      // Ignorar error en carga inicial
    }
  }

  Future<void> _handleRefresh() async {
    await context.read<ProductProvider>().refreshProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final showSkeleton = _initialLoading || productProvider.isLoading;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xff0F1115) : const Color(0xffF5F6FA),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _handleRefresh,
        color: const Color(0xff4F6EF7),
        backgroundColor: isDark ? const Color(0xff2A2D36) : Colors.white,
        displacement: 40,
        strokeWidth: 2.5,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            // AppBar
            const HomeSliverAppBar(),

            // Banner optimizado
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [
                            const Color(0xff2A2D36),
                            const Color(0xff1C1F26),
                          ]
                        : [
                            Colors.white,
                            const Color(0xffFAFBFF),
                          ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xff3A3F4B)
                        : const Color(0xffE2E6F0),
                    width: 1.5,
                  ),
                  // Sombra sutil para profundidad
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withOpacity(0.2)
                          : Colors.black.withOpacity(0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Ícono con mejor affordance
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xff4F6EF7).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.local_offer_rounded,
                        size: 20,
                        color: Color(0xff4F6EF7),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Texto más legible
                    Expanded(
                      child: Text(
                        'Explora nuestros productos',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? const Color(0xffE8E9ED)
                              : const Color(0xff1A1D2E),
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Espaciado con proporción áurea  en 24 pixeles
            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Header con jerarquía visual
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Productos',
                  style: TextStyle(
                    fontSize: 26, // Aumentado para mejor jerarquía visual
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    color: isDark
                        ? const Color(0xffFFFFFF)
                        : const Color(0xff0F1115),
                  ),
                ),
              ),
            ),

            // Error message mejorado
            if (productProvider.hasError)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xffFF9500).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xffFF9500).withOpacity(0.4),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          color: const Color(0xffFF9500),
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            productProvider.error ??
                                'Error al cargar productos',
                            style: TextStyle(
                              color: isDark
                                  ? const Color(0xffE8E9ED)
                                  : const Color(0xff1A1D2E),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // Grid de productos con mejor espaciado
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: _buildProductGrid(productProvider, isDark, showSkeleton),
            ),

            // Empty state con mejor jerarquía visual
            if (!showSkeleton && productProvider.products.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 60, horizontal: 32),
                  child: Column(
                    children: [
                      // Ícono con mejor contraste
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xff2A2D36)
                              : const Color(0xffF5F6FA),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.inventory_2_outlined,
                          size: 48,
                          color: isDark
                              ? Colors.grey[600]
                              : const Color(0xff9CA3AF),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Texto con mejor jerarquía
                      Text(
                        'No hay productos',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? const Color(0xffE8E9ED)
                              : const Color(0xff1A1D2E),
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Agrega tu primer producto',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark
                              ? Colors.grey[500]
                              : const Color(0xff6B7280),
                          letterSpacing: -0.1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }

  // Grid de productos con mejor espaciado
  Widget _buildProductGrid(
      ProductProvider productProvider, bool isDark, bool showSkeleton) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (showSkeleton) {
            // Skeleton con mejor contraste y affordance
            return Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xff1C1F26) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark
                      ? const Color(0xff2A2D36)
                      : const Color(0xffE2E6F0),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.1 : 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Imagen skeleton
                  Expanded(
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xff2A2D36)
                            : const Color(0xffF5F6FA),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                    ),
                  ),

                  // Texto skeleton con mejor espaciado
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 14,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xff3A3F4B)
                                : const Color(0xffE2E6F0),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 12,
                          width: 70,
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xff3A3F4B)
                                : const Color(0xffE2E6F0),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          if (productProvider.products.isEmpty) {
            return const SizedBox.shrink();
          }

          final product = productProvider.products[index];

          // ProductCard con mejor affordance
          return ProductCard(
            product: product,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductDetailScreen(product: product),
                ),
              );
            },
          );
        },
        childCount: showSkeleton ? 6 : productProvider.products.length,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16, // Espaciado consistente
        crossAxisSpacing: 16, // Espaciado consistente
        childAspectRatio: 0.85, // Proporción equilibrada
      ),
    );
  }
}