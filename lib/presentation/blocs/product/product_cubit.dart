import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homeshop/core/constants/api_constants.dart';
import 'package:homeshop/core/utils/logger.dart';
import 'package:homeshop/domain/repositories/product_repository.dart';
import 'package:homeshop/presentation/blocs/product/product_state.dart';

/// Product Cubit - Manages product-related state
///
/// Handles:
/// - Fetching products with pagination
/// - Loading categories
/// - Searching products
/// - Getting product details
/// - Filtering by category
class ProductCubit extends Cubit<ProductState> {
  final ProductRepository _repository;

  ProductCubit(this._repository) : super(const ProductInitial());

  /// Load products with pagination
  ///
  /// [refresh] - If true, clears existing products and loads from beginning
  Future<void> loadProducts({bool refresh = false}) async {
    try {
      final currentState = state;

      // If refreshing or initial load, reset state
      if (refresh || currentState is! ProductLoaded) {
        emit(const ProductLoading());

        final result = await _repository.getProducts(
          offset: 0,
          limit: ApiConstants.defaultPageSize,
        );

        result.fold(
          (error) {
            AppLogger.error('Failed to load products: $error');
            emit(ProductError(error));
          },
          (products) {
            AppLogger.info('Loaded ${products.length} products');
            emit(ProductLoaded(
              products: products,
              hasReachedMax: products.length < ApiConstants.defaultPageSize,
              currentPage: 1,
            ));
          },
        );
      } else if (currentState is ProductLoaded && !currentState.hasReachedMax) {
        // Load more products (pagination)
        final nextPage = currentState.currentPage + 1;
        final offset = currentState.currentPage * ApiConstants.defaultPageSize;

        final result = await _repository.getProducts(
          offset: offset,
          limit: ApiConstants.defaultPageSize,
        );

        result.fold(
          (error) {
            AppLogger.error('Failed to load more products: $error');
            // Keep current state on error
          },
          (newProducts) {
            AppLogger.info('Loaded ${newProducts.length} more products');

            final updatedProducts = [
              ...currentState.products,
              ...newProducts,
            ];

            emit(ProductLoaded(
              products: updatedProducts,
              hasReachedMax: newProducts.length < ApiConstants.defaultPageSize,
              currentPage: nextPage,
            ));
          },
        );
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error loading products', e, stackTrace);
      emit(ProductError(e.toString()));
    }
  }

  /// Load products by category
  ///
  /// [categoryId] - ID of the category to filter by
  Future<void> loadProductsByCategory(int categoryId) async {
    try {
      emit(const ProductLoading());

      AppLogger.info('Loading products for category: $categoryId');

      final result = await _repository.getProductsByCategory(
        categoryId: categoryId,
        offset: 0,
        limit: ApiConstants.maxPageSize,
      );

      result.fold(
        (error) {
          AppLogger.error('Failed to load category products: $error');
          emit(ProductError(error));
        },
        (products) {
          AppLogger.info('Loaded ${products.length} products for category');
          emit(ProductLoaded(
            products: products,
            hasReachedMax: true,
            currentPage: 1,
          ));
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error('Error loading category products', e, stackTrace);
      emit(ProductError(e.toString()));
    }
  }

  /// Load all categories
  Future<void> loadCategories() async {
    try {
      AppLogger.info('Loading categories');

      final result = await _repository.getCategories();

      result.fold(
        (error) {
          AppLogger.error('Failed to load categories: $error');
          emit(ProductError(error));
        },
        (categories) {
          AppLogger.info('Loaded ${categories.length} categories');
          emit(CategoriesLoaded(categories));
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error('Error loading categories', e, stackTrace);
      emit(ProductError(e.toString()));
    }
  }

  /// Load product details by ID
  ///
  /// [productId] - ID of the product to load
  Future<void> loadProductDetail(int productId) async {
    try {
      emit(const ProductLoading());

      AppLogger.info('Loading product detail: $productId');

      final result = await _repository.getProductById(productId);

      result.fold(
        (error) {
          AppLogger.error('Failed to load product detail: $error');
          emit(ProductError(error));
        },
        (product) {
          AppLogger.info('Loaded product: ${product.title}');
          emit(ProductDetailLoaded(product));
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error('Error loading product detail', e, stackTrace);
      emit(ProductError(e.toString()));
    }
  }

  /// Search products by query
  ///
  /// [query] - Search query string
  Future<void> searchProducts(String query) async {
    try {
      if (query.isEmpty) {
        // If query is empty, load all products
        await loadProducts(refresh: true);
        return;
      }

      emit(const ProductLoading());

      AppLogger.info('Searching products: $query');

      final result = await _repository.searchProducts(
        query: query,
        offset: 0,
        limit: ApiConstants.maxPageSize,
      );

      result.fold(
        (error) {
          AppLogger.error('Failed to search products: $error');
          emit(ProductError(error));
        },
        (products) {
          AppLogger.info('Found ${products.length} products for "$query"');
          emit(SearchResultsLoaded(
            results: products,
            query: query,
          ));
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error('Error searching products', e, stackTrace);
      emit(ProductError(e.toString()));
    }
  }

  /// Refresh products (pull-to-refresh)
  Future<void> refreshProducts() async {
    await loadProducts(refresh: true);
  }
}
