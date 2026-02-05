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
  late Timer _autoRefreshTimer;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  int _lastProductCount = 0;
  bool _showNewProductsBadge = false;

  @override
  void initState() {
    super.initState();
    
    // Cargar productos iniciales
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialProducts();
    });
    
    // Timer para carga inicial visual
    Timer(const Duration(milliseconds: 900), () {
      if (mounted) {
        setState(() => _initialLoading = false);
      }
    });
    
    // Auto-refresh cada 5 minutos
    _startAutoRefreshTimer();
  }

  @override
  void dispose() {
    _autoRefreshTimer.cancel();
    super.dispose();
  }

  void _startAutoRefreshTimer() {
    _autoRefreshTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
      if (mounted) {
        _performAutoRefresh();
      }
    });
  }

  Future<void> _loadInitialProducts() async {
    try {
      await context.read<ProductProvider>().loadProducts();
      _lastProductCount = context.read<ProductProvider>().products.length;
    } catch (e) {
      // Ignorar error en carga inicial
    }
  }

  Future<void> _performAutoRefresh() async {
    final provider = context.read<ProductProvider>();
    final previousCount = provider.products.length;
    
    try {
      final hadChanges = await provider.silentRefresh();
      
      // Mostrar badge si hubo cambios
      if (hadChanges && mounted) {
        setState(() {
          _showNewProductsBadge = true;
        });
        
        // Ocultar badge después de 3 segundos
        Timer(const Duration(seconds: 3), () {
          if (mounted) {
            setState(() {
              _showNewProductsBadge = false;
            });
          }
        });
        
        _lastProductCount = provider.products.length;
      }
    } catch (e) {
      // Silenciar errores en auto-refresh
    }
  }

  Future<void> _handleRefresh() async {
    final provider = context.read<ProductProvider>();
    final previousCount = provider.products.length;
    
    await provider.refreshProducts();
    final newCount = provider.products.length;
    
    // Actualizar contador para badge
    _lastProductCount = newCount;
    
    // Mostrar snackbar sutil si hay nuevos productos
    if (newCount > previousCount && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${newCount - previousCount} nuevos productos'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _resetBadge() {
    if (_showNewProductsBadge && mounted) {
      setState(() {
        _showNewProductsBadge = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final showSkeleton = _initialLoading || productProvider.isLoading;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xff0F1115) : const Color(0xffF5F6FA),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _handleRefresh,
        color: const Color(0xff4F6EF7),
        backgroundColor: isDark ? const Color(0xff2A2D36) : Colors.white,
        displacement: 40,
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            // Ocultar badge cuando el usuario hace scroll
            if (notification is ScrollUpdateNotification) {
              _resetBadge();
            }
            return false;
          },
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              // AppBar original sin cambios
              const HomeSliverAppBar(),

              // Banner promocional original
              SliverPersistentHeader(
                pinned: false,
                delegate: _PromoBannerDelegate(isDark: isDark),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 32)),

              // Título simple "Productos"
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Productos',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              // Badge de nuevos productos (solo cuando hay)
              if (_showNewProductsBadge)
                SliverToBoxAdapter(
                  child: GestureDetector(
                    onTap: _resetBadge,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.new_releases, size: 16, color: Colors.green),
                          const SizedBox(width: 8),
                          Text(
                            'Nuevos productos disponibles',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // Error message solo si hay error
              if (productProvider.hasError)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: Colors.orange),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Error: ${productProvider.error}',
                              style: const TextStyle(color: Colors.orange),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 20)),

              // Grid de productos (sin contador, sin extras)
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (showSkeleton) {
                        return const _SkeletonCard();
                      }

                      if (productProvider.products.isEmpty) {
                        return Container(
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xff1C1F26) : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Center(
                            child: Text(
                              'No hay productos',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        );
                      }

                      final product = productProvider.products[index];
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
                    childCount: showSkeleton 
                      ? 4 
                      : productProvider.products.isEmpty 
                        ? 1 
                        : productProvider.products.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.90,
                  ),
                ),
              ),

              // Empty state minimalista
              if (!showSkeleton && productProvider.products.isEmpty)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(Icons.inventory_outlined, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No hay productos disponibles',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 28)),
            ],
          ),
        ),
      ),
    );
  }
}

// Delegate para el banner promocional (original)
class _PromoBannerDelegate extends SliverPersistentHeaderDelegate {
  final bool isDark;

  _PromoBannerDelegate({required this.isDark});

  @override
  double get minExtent => 0;

  @override
  double get maxExtent => 120;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    // Opacidad progresiva al hacer scroll
    final opacity = 1 - (shrinkOffset / maxExtent);

    return Opacity(
      opacity: opacity.clamp(0, 1),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xff2A2D36)
              : const Color(0xff4F6EF7).withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark
                ? const Color(0xff3A3F4B)
                : const Color(0xff4F6EF7).withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '30% de descuento',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xff4F6EF7),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'En productos seleccionados',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.grey[400] : Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.local_offer_rounded,
              size: 40,
              color: Color(0xff4F6EF7),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(
    covariant SliverPersistentHeaderDelegate oldDelegate,
  ) {
    return true;
  }
}

// Tarjeta skeleton para estado de carga (original)
class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xff1C1F26) : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Área simulada de imagen
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
            ),
          ),
          // Texto simulado
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Container(
                  height: 12,
                  width: double.infinity,
                  color: Colors.grey.withOpacity(0.3),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 12,
                  width: 60,
                  color: Colors.grey.withOpacity(0.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}