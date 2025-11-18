import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homeshop/core/di/injection.dart';
import 'package:homeshop/core/theme/app_colors.dart';
import 'package:homeshop/data/models/category_model.dart';
import 'package:homeshop/presentation/blocs/product/product_cubit.dart';
import 'package:homeshop/presentation/blocs/product/product_state.dart';

/// Category Chip List - Horizontal scrollable category chips
///
/// Features:
/// - Loads categories from API
/// - Horizontal scroll
/// - Click to filter products
/// - Active state indicator
class CategoryChipList extends StatefulWidget {
  const CategoryChipList({super.key});

  @override
  State<CategoryChipList> createState() => _CategoryChipListState();
}

class _CategoryChipListState extends State<CategoryChipList> {
  int? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    // Load categories using a separate cubit instance
    _loadCategories();
  }

  void _loadCategories() {
    // Create a temporary cubit to load categories
    final categoryCubit = getIt<ProductCubit>();
    categoryCubit.loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProductCubit>()..loadCategories(),
      child: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          if (state is CategoriesLoaded) {
            return _CategoryList(
              categories: state.categories,
              selectedCategoryId: _selectedCategoryId,
              onCategorySelected: (categoryId) {
                setState(() {
                  _selectedCategoryId = categoryId;
                });

                // Filter products by category
                if (categoryId == null) {
                  context.read<ProductCubit>().loadProducts(refresh: true);
                } else {
                  context
                      .read<ProductCubit>()
                      .loadProductsByCategory(categoryId);
                }
              },
            );
          } else if (state is ProductError) {
            return const SizedBox.shrink();
          }

          // Loading state - show placeholder chips
          return _LoadingCategoryList();
        },
      ),
    );
  }
}

/// Category List Widget
class _CategoryList extends StatelessWidget {
  final List<CategoryModel> categories;
  final int? selectedCategoryId;
  final Function(int?) onCategorySelected;

  const _CategoryList({
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Categories',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length + 1, // +1 for "All" chip
            itemBuilder: (context, index) {
              if (index == 0) {
                // "All" chip
                return _CategoryChip(
                  label: 'All',
                  isSelected: selectedCategoryId == null,
                  onTap: () => onCategorySelected(null),
                );
              }

              final category = categories[index - 1];
              return _CategoryChip(
                label: category.name,
                isSelected: selectedCategoryId == category.id,
                onTap: () => onCategorySelected(category.id),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

/// Category Chip Widget
class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            gradient: isSelected ? AppColors.primaryGradient : null,
            color: isSelected ? null : AppColors.greyLight,
            borderRadius: BorderRadius.circular(25),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.textPrimary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}

/// Loading Category List - Placeholder while loading
class _LoadingCategoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 66,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            width: 100,
            height: 40,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: AppColors.greyLight,
              borderRadius: BorderRadius.circular(25),
            ),
          );
        },
      ),
    );
  }
}
