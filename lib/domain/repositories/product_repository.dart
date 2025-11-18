import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:homeshop/data/models/category_model.dart';
import 'package:homeshop/data/models/product_model.dart';

/// Product repository interface
abstract class ProductRepository {
  /// Get all products with pagination
  Future<Either<String, List<ProductModel>>> getProducts({
    int offset = 0,
    int limit = 10,
  });

  /// Get product by ID
  Future<Either<String, ProductModel>> getProductById(int id);

  /// Get products by category
  Future<Either<String, List<ProductModel>>> getProductsByCategory({
    required int categoryId,
    int offset = 0,
    int limit = 10,
  });

  /// Search products by title
  Future<Either<String, List<ProductModel>>> searchProducts({
    required String query,
    int offset = 0,
    int limit = 10,
  });

  /// Get all categories
  Future<Either<String, List<CategoryModel>>> getCategories();

  /// Get category by ID
  Future<Either<String, CategoryModel>> getCategoryById(int id);

  /// Create a new product (Admin only)
  Future<Either<String, ProductModel>> createProduct({
    required String title,
    required double price,
    required String description,
    required int categoryId,
    required List<String> images,
  });

  /// Update a product (Admin only)
  Future<Either<String, ProductModel>> updateProduct({
    required int id,
    String? title,
    double? price,
    String? description,
    int? categoryId,
    List<String>? images,
  });

  /// Delete a product (Admin only)
  Future<Either<String, bool>> deleteProduct(int id);

  /// Upload file/image
  Future<Either<String, String>> uploadFile(File file);
}
