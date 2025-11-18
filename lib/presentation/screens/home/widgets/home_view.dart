import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:homeshop/core/router/route_names.dart';
import 'package:homeshop/core/theme/app_colors.dart';
import 'package:homeshop/core/widgets/animated_product_card.dart';
import 'package:homeshop/core/widgets/empty_state_widget.dart';
import 'package:homeshop/core/widgets/shimmer_loading.dart';
import 'package:homeshop/data/models/product_model.dart';
import 'package:homeshop/presentation/blocs/cart/cart_cubit.dart';
import 'package:homeshop/presentation/blocs/cart/cart_state.dart';
import 'package:homeshop/presentation/blocs/product/product_cubit.dart';
import 'package:homeshop/presentation/blocs/product/product_state.dart';
import 'package:homeshop/presentation/screens/home/widgets/category_chip_list.dart';
import 'package:homeshop/presentation/screens/home/widgets/featured_carousel.dart';
import 'package:homeshop/presentation/screens/home/widgets/home_app_bar.dart';

/// Home View - UI Component (Stateless, logic-free)
///
/// Features:
/// - Product carousel
/// - Category chips
/// - Product grid with stagger animation
/// - Pull-to-refresh
/// - Responsive layout
/// - Loading/Error/Empty states
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const HomeAppBar(),
      body: BlocConsumer<ProductCubit, ProductState>(
        listener: (context, state) {
          // Handle error states with SnackBar
          if (state is ProductError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
                action: SnackBarAction(
                  label: 'Retry',
                  textColor: Colors.white,
                  onPressed: () {
                    context.read<ProductCubit>().loadProducts(refresh: true);
                  },
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ProductLoading) {
            return const _LoadingView();
          } else if (state is ProductLoaded) {
            return _ProductsView(
              products: state.products,
              hasReachedMax: state.hasReachedMax,
            );
          } else if (state is ProductError) {
            return ErrorStateWidget(
              message: state.message,
              onRetry: () {
                context.read<ProductCubit>().loadProducts(refresh: true);
              },
            );
          }

          // Initial state
          return const Center(child: CircularProgressIndicator());
        },
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: const _BottomNavBar(),
    );
  }
}

/// Products view with carousel and grid
class _ProductsView extends StatefulWidget {
  final List<ProductModel> products;
  final bool hasReachedMax;

  const _ProductsView({
    required this.products,
    required this.hasReachedMax,
  });

  @override
  State<_ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<_ProductsView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Setup infinite scroll
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Handle scroll for pagination
  void _onScroll() {
    if (_isBottom && !widget.hasReachedMax) {
      context.read<ProductCubit>().loadProducts();
    }
  }

  /// Check if scrolled to bottom
  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.products.isEmpty) {
      return const EmptyStateWidget(
        title: 'No Products',
        message: 'No products available at the moment.',
        icon: Icons.shopping_bag_outlined,
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<ProductCubit>().refreshProducts(),
      color: AppColors.primary,
      child: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // Featured Carousel
          SliverToBoxAdapter(
            child: FeaturedCarousel(
              products: widget.products.take(5).toList(),
            ),
          ),

          // Category Chips
          const SliverToBoxAdapter(
            child: CategoryChipList(),
          ),

          // Section Title
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'All Products',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),

          // Product Grid with Stagger Animation
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: _ResponsiveProductGrid(
              products: widget.products,
            ),
          ),

          // Loading more indicator
          if (!widget.hasReachedMax)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),

          // Bottom spacing
          const SliverToBoxAdapter(
            child: SizedBox(height: 16),
          ),
        ],
      ),
    );
  }
}

/// Responsive product grid
class _ResponsiveProductGrid extends StatelessWidget {
  final List<ProductModel> products;

  const _ResponsiveProductGrid({required this.products});

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _getCrossAxisCount(context),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.7,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final product = products[index];

          // Stagger animation
          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: const Duration(milliseconds: 375),
            columnCount: _getCrossAxisCount(context),
            child: ScaleAnimation(
              child: FadeInAnimation(
                child: AnimatedProductCard(
                  imageUrl: product.images.isNotEmpty
                      ? product.images.first
                      : '',
                  title: product.title,
                  price: '\$${product.price.toStringAsFixed(2)}',
                  category: product.category.name,
                  heroTag: 'product-${product.id}',
                  onTap: () {
                    context.push(
                      '${RouteNames.productDetail}/${product.id}',
                      extra: product,
                    );
                  },
                  onAddToCart: () {
                    context.read<CartCubit>().addToCart(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${product.title} added to cart'),
                        duration: const Duration(seconds: 2),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
        childCount: products.length,
      ),
    );
  }

  /// Get cross axis count based on screen width
  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 4;
    if (width > 800) return 3;
    return 2;
  }
}

/// Loading view with shimmer
class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _getCrossAxisCount(context),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.7,
      ),
      itemCount: 6,
      itemBuilder: (context, index) => const ProductCardShimmer(),
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 4;
    if (width > 800) return 3;
    return 2;
  }
}

/// Bottom Navigation Bar
class _BottomNavBar extends StatefulWidget {
  const _BottomNavBar();

  @override
  State<_BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<_BottomNavBar> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: BlocBuilder<CartCubit, CartState>(
            builder: (context, cartState) {
              // Get cart item count from state
              final cartCount = cartState is CartLoaded ? cartState.itemCount : 0;

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavBarItem(
                    icon: Icons.home,
                    label: 'Home',
                    isSelected: _selectedIndex == 0,
                    onTap: () => setState(() => _selectedIndex = 0),
                    badge: null,
                  ),
                  _NavBarItem(
                    icon: Icons.category,
                    label: 'Categories',
                    isSelected: _selectedIndex == 1,
                    onTap: () {
                      setState(() => _selectedIndex = 1);
                      context.push(RouteNames.categories);
                    },
                    badge: null,
                  ),
                  _NavBarItem(
                    icon: Icons.shopping_cart,
                    label: 'Cart',
                    isSelected: _selectedIndex == 2,
                    onTap: () {
                      setState(() => _selectedIndex = 2);
                      context.push(RouteNames.cart);
                    },
                    badge: cartCount > 0 ? cartCount : null,
                  ),
                  _NavBarItem(
                    icon: Icons.person,
                    label: 'Profile',
                    isSelected: _selectedIndex == 3,
                    onTap: () {
                      setState(() => _selectedIndex = 3);
                      context.push(RouteNames.profile);
                    },
                    badge: null,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Navigation Bar Item
class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final int? badge;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon,
                  color: isSelected ? AppColors.primary : AppColors.grey,
                  size: 28,
                ),
                if (badge != null && badge! > 0)
                  Positioned(
                    right: -8,
                    top: -8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.secondary,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Text(
                        badge! > 9 ? '9+' : badge.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? AppColors.primary : AppColors.grey,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
