import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommerce_app/core/di/injection.dart';
import 'package:ecommerce_app/features/product/domain/entities/product_entity.dart';
import 'package:ecommerce_app/features/product/presentation/bloc/product_bloc.dart';
import 'package:ecommerce_app/features/search/domain/entities/search_result.dart'; // For initial data
import 'package:ecommerce_app/features/search/presentation/widgets/product_card.dart'; // Reuse
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
     final extra = GoRouterState.of(context).extra;
     final String productId = (extra is SearchResult) ? extra.id : '1'; 

    return BlocProvider(
      create: (context) => getIt<ProductBloc>()..add(LoadProductDetails(productId)),
      child: const ProductView(),
    );
  }
}

class ProductView extends StatefulWidget {
  const ProductView({super.key});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.favorite_border, color: Colors.black), onPressed: () {}),
          IconButton(icon: const Icon(Icons.share, color: Colors.black), onPressed: () {}),
        ],
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductLoaded) {
            return _buildProductContent(state.product, state.relatedProducts);
          } else if (state is ProductError) {
             return Center(child: Text('Error: ${state.message}'));
          }
          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildProductContent(ProductEntity product, List<dynamic> related) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Carousel
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  height: 400,
                  viewportFraction: 1.0,
                  enableInfiniteScroll: false,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentImageIndex = index;
                    });
                  },
                ),
                items: product.images.map((img) {
                  return Builder(
                    builder: (BuildContext context) {
                      return CachedNetworkImage(
                        imageUrl: img,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      );
                    },
                  );
                }).toList(),
              ),
              Positioned(
                bottom: 20,
                child: AnimatedSmoothIndicator(
                  activeIndex: _currentImageIndex,
                  count: product.images.length,
                  effect: const ExpandingDotsEffect(
                    activeDotColor: Colors.black,
                    dotColor: Colors.grey,
                    dotHeight: 8,
                    dotWidth: 8,
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Brand Logic
                Text(
                  product.brand.toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Text(
                  product.name,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                 Row(
                  children: [
                    RatingBarIndicator(
                      rating: product.rating,
                      itemBuilder: (context, index) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 16.0,
                      direction: Axis.horizontal,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${product.rating} (${product.reviews} reviews)',
                      style: const TextStyle(fontSize: 12, color: Colors.black87),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                const Text(
                  "Description",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                 Text(
                  product.description,
                  style: const TextStyle(fontSize: 14, height: 1.5, color: Colors.black87),
                ),
                
                 const SizedBox(height: 32),
                 const Text(
                  "You may also like",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 16),
                
                // Related Products
                SizedBox(
                  height: 220,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: related.length,
                    itemBuilder: (context, index) {
                      // Reuse ProductCard but resize it
                      return Container(
                        width: 160,
                        margin: const EdgeInsets.only(right: 16),
                        child: ProductCard(product: related[index]),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 80), // Space for bottom bar
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -4),
            blurRadius: 10,
          )
        ],
      ),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE80022), // Sephora Red
            minimumSize: const Size(double.infinity, 50),
          ),
          child: const Text(
            "Add to Basket",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
