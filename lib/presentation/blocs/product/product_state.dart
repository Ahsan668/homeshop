import 'package:equatable/equatable.dart';
import 'package:homeshop/data/models/category_model.dart';
import 'package:homeshop/data/models/product_model.dart';

/// Product states following clean architecture principles
abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

/// Initial state - No data loaded yet
class ProductInitial extends ProductState {
  const ProductInitial();
}

/// Loading state - Fetching products from API
class ProductLoading extends ProductState {
  const ProductLoading();
}

/// Loaded state - Products successfully fetched
class ProductLoaded extends ProductState {
  final List<ProductModel> products;
  final bool hasReachedMax;
  final int currentPage;

  const ProductLoaded({
    required this.products,
    this.hasReachedMax = false,
    this.currentPage = 0,
  });

  @override
  List<Object?> get props => [products, hasReachedMax, currentPage];

  ProductLoaded copyWith({
    List<ProductModel>? products,
    bool? hasReachedMax,
    int? currentPage,
  }) {
    return ProductLoaded(
      products: products ?? this.products,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

/// Error state - Failed to fetch products
class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Categories loaded state
class CategoriesLoaded extends ProductState {
  final List<CategoryModel> categories;

  const CategoriesLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}

/// Product detail loaded state
class ProductDetailLoaded extends ProductState {
  final ProductModel product;

  const ProductDetailLoaded(this.product);

  @override
  List<Object?> get props => [product];
}

/// Search results loaded state
class SearchResultsLoaded extends ProductState {
  final List<ProductModel> results;
  final String query;

  const SearchResultsLoaded({
    required this.results,
    required this.query,
  });

  @override
  List<Object?> get props => [results, query];
}
