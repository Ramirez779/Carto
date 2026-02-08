import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:carto/models/product.dart';
import 'package:carto/providers/product_provider.dart';
import 'package:carto/screens/product/product_detail_screen.dart';
import 'package:carto/widgets/home_sliver_app.dart';
import 'package:carto/widgets/product_card.dart';

/// HomeScree
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

    //Cargar productos iniciales
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
            // AppBar simple
            const HomeSliverAppBar(),

            // Banner simple y minimalista
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                padding: const EdgeInsets.all(16),
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
                            Colors.white,
                          ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xff3A3F4B)
                        : const Color(0xffE2E6F0),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    // Ícono simple
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xff4F6EF7).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.local_offer_rounded,
                        size: 22,
                        color: Color(0xff4F6EF7),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Texto simple
                    const Expanded(
                      child: Text(
                        'Explora nuestros productos',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff1A1D2E),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Text(
                  'Productos',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
            ),

            //Error message simplificado
            if (productProvider.hasError)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xffFF9500).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: const Color(0xffFF9500).withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          color: const Color(0xffFF9500),
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            productProvider.error ??
                                'Error al cargar productos',
                            style: TextStyle(
                              color:
                                  isDark ? Colors.grey[300] : Colors.grey[700],
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // Grid de productos
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: _buildProductGrid(productProvider, isDark, showSkeleton),
            ),

            // Empty state simplificado
            if (!showSkeleton && productProvider.products.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 64,
                        color: isDark ? Colors.grey[600] : Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No hay productos',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.grey[300] : Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Agrega tu primer producto',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
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

  // Grid de productos
  Widget _buildProductGrid(
      ProductProvider productProvider, bool isDark, bool showSkeleton) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (showSkeleton) {
            // Skeleton
            return Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xff1C1F26) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
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
                        color: isDark ? Colors.grey[800] : Colors.grey[200],
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                    ),
                  ),

                  // Texto skeleton
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 14,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: isDark ? Colors.grey[700] : Colors.grey[300],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 12,
                          width: 70,
                          decoration: BoxDecoration(
                            color: isDark ? Colors.grey[700] : Colors.grey[300],
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

          // ProductCard simple
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
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.85, // Mejor proporción para las cards
      ),
    );
  }
}