import 'dart:async';
import 'package:flutter/material.dart';

import 'package:carto/models/product.dart';
import 'package:carto/screens/product/product_detail_screen.dart';
import 'package:carto/widgets/home_sliver_app.dart';
import 'package:carto/widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;

  final List<Product> products = [
    Product(
      id: 'p1',
      title: 'Auriculares',
      price: 29.99,
      image:
          'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400',
    ),
    Product(
      id: 'p2',
      title: 'Smart Watch',
      price: 59.99,
      image:
          'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400',
    ),
    Product(
      id: 'p3',
      title: 'Teclado',
      price: 89.99,
      image:
          'https://images.unsplash.com/photo-1541140532154-b024d705b90a?w=400',
    ),
    Product(
      id: 'p4',
      title: 'Mouse Gamer',
      price: 19.99,
      image:
          'https://images.unsplash.com/photo-1527814050087-3793815479db?w=400',
    ),
    Product(
      id: 'p5',
      title: 'Auriculares Pro',
      price: 89.99,
      image:
          'https://images.unsplash.com/photo-1583394838336-acd977736f90?w=400',
    ),
    Product(
      id: 'p6',
      title: 'Smart Watch Elite',
      price: 199.99,
      image:
          'https://images.unsplash.com/photo-1434493650001-5d43a6fea0c8?w=400',
    ),
    Product(
      id: 'p7',
      title: 'Teclado Mecánico',
      price: 129.99,
      image:
          'https://images.unsplash.com/photo-1629654291660-3c98113a0438?w=400',
    ),
    Product(
      id: 'p8',
      title: 'Mouse RGB',
      price: 59.99,
      image:
          'https://images.unsplash.com/photo-1615663248957-c5b8d96c24a9?w=400',
    ),
    Product(
      id: 'p9',
      title: 'Monitor 4K',
      price: 349.99,
      image:
          'https://images.unsplash.com/photo-1593359677879-a4bb92f829d1?w=400',
    ),
    Product(
      id: 'p10',
      title: 'Laptop',
      price: 899.99,
      image:
          'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=400',
    ),
    Product(
      id: 'p11',
      title: 'Cámara',
      price: 699.99,
      image:
          'https://images.unsplash.com/photo-1510127034890-ba27508e9f1c?w=400',
    ),
    Product(
      id: 'p12',
      title: 'Altavoz',
      price: 79.99,
      image: 'https://images.unsplash.com/photo-1546435770-a3e426bf472b?w=400',
    ),
    Product(
      id: 'p13',
      title: 'Tablet',
      price: 299.99,
      image: 'https://images.unsplash.com/photo-1546054451-aa6a150c5c3d?w=400',
    ),
    Product(
      id: 'p14',
      title: 'Mochila',
      price: 49.99,
      image: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=400',
    ),
    Product(
      id: 'p15',
      title: 'Lámpara',
      price: 34.99,
      image:
          'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?w=400',
    ),
    Product(
      id: 'p16',
      title: 'Cafetera',
      price: 89.99,
      image:
          'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=400',
    ),
  ];

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 900), () {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xff0F1115) : const Color(0xffF5F6FA),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          const HomeSliverAppBar(),
          SliverPersistentHeader(
            pinned: false,
            delegate: _PromoBannerDelegate(isDark: isDark),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 32),
          ),
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
          const SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (_isLoading) {
                    return const _SkeletonCard();
                  }

                  final product = products[index];

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
                childCount: _isLoading ? 4 : products.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.90,
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 28),
          ),
        ],
      ),
    );
  }
}

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
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

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
