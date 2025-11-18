import 'dart:io';
import 'package:dio/dio.dart';
import 'package:homeshop/core/constants/api_constants.dart';
import 'package:homeshop/core/utils/logger.dart';
import 'package:homeshop/data/models/category_model.dart';
import 'package:homeshop/data/models/product_model.dart';
import 'package:homeshop/data/services/network/dio_client.dart';

/// Product API service for Platzi Fake Store API
class ProductApiService {
  final DioClient _dioClient;

  ProductApiService(this._dioClient);

  /// Get all products with pagination
  Future<List<ProductModel>> getProducts({
    int offset = 0,
    int limit = ApiConstants.defaultPageSize,
  }) async {
    try {
      AppLogger.info('Fetching products: offset=$offset, limit=$limit');

      final response = await _dioClient.get(
        ApiConstants.products,
        queryParameters: {
          'offset': offset,
          'limit': limit,
        },
      );

      final products = (response.data as List)
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .toList();

      AppLogger.info('Fetched ${products.length} products');
      return products;
    } catch (e, stackTrace) {
      AppLogger.error('Failed to fetch products', e, stackTrace);
      rethrow;
    }
  }

  /// Get product by ID
  Future<ProductModel> getProductById(int id) async {
    try {
      AppLogger.info('Fetching product by ID: $id');

      final response = await _dioClient.get(
        ApiConstants.productById(id),
      );

      final product = ProductModel.fromJson(response.data);
      AppLogger.info('Fetched product: ${product.title}');
      return product;
    } catch (e, stackTrace) {
      AppLogger.error('Failed to fetch product by ID', e, stackTrace);
      rethrow;
    }
  }

  /// Get products by category
  Future<List<ProductModel>> getProductsByCategory({
    required int categoryId,
    int offset = 0,
    int limit = ApiConstants.defaultPageSize,
  }) async {
    try {
      AppLogger.info('Fetching products by category: $categoryId');

      final response = await _dioClient.get(
        ApiConstants.products,
        queryParameters: {
          'categoryId': categoryId,
          'offset': offset,
          'limit': limit,
        },
      );

      final products = (response.data as List)
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .toList();

      AppLogger.info('Fetched ${products.length} products for category $categoryId');
      return products;
    } catch (e, stackTrace) {
      AppLogger.error('Failed to fetch products by category', e, stackTrace);
      rethrow;
    }
  }

  /// Search products by title
  Future<List<ProductModel>> searchProducts({
    required String query,
    int offset = 0,
    int limit = ApiConstants.defaultPageSize,
  }) async {
    try {
      AppLogger.info('Searching products: query=$query');

      final response = await _dioClient.get(
        ApiConstants.products,
        queryParameters: {
          'title': query,
          'offset': offset,
          'limit': limit,
        },
      );

      final products = (response.data as List)
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .toList();

      AppLogger.info('Found ${products.length} products matching "$query"');
      return products;
    } catch (e, stackTrace) {
      AppLogger.error('Failed to search products', e, stackTrace);
      rethrow;
    }
  }

  /// Get all categories
  Future<List<CategoryModel>> getCategories() async {
    try {
      AppLogger.info('Fetching categories');

      final response = await _dioClient.get(ApiConstants.categories);

      final categories = (response.data as List)
          .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
          .toList();

      AppLogger.info('Fetched ${categories.length} categories');
      return categories;
    } catch (e, stackTrace) {
      AppLogger.error('Failed to fetch categories', e, stackTrace);
      rethrow;
    }
  }

  /// Get category by ID
  Future<CategoryModel> getCategoryById(int id) async {
    try {
      AppLogger.info('Fetching category by ID: $id');

      final response = await _dioClient.get(
        ApiConstants.categoryById(id),
      );

      final category = CategoryModel.fromJson(response.data);
      AppLogger.info('Fetched category: ${category.name}');
      return category;
    } catch (e, stackTrace) {
      AppLogger.error('Failed to fetch category by ID', e, stackTrace);
      rethrow;
    }
  }

  /// Create a new product (Admin only)
  Future<ProductModel> createProduct({
    required String title,
    required double price,
    required String description,
    required int categoryId,
    required List<String> images,
  }) async {
    try {
      AppLogger.info('Creating new product: $title');

      final response = await _dioClient.post(
        ApiConstants.products,
        data: {
          'title': title,
          'price': price,
          'description': description,
          'categoryId': categoryId,
          'images': images,
        },
      );

      final product = ProductModel.fromJson(response.data);
      AppLogger.info('Created product: ${product.title}');
      return product;
    } catch (e, stackTrace) {
      AppLogger.error('Failed to create product', e, stackTrace);
      rethrow;
    }
  }

  /// Update a product (Admin only)
  Future<ProductModel> updateProduct({
    required int id,
    String? title,
    double? price,
    String? description,
    int? categoryId,
    List<String>? images,
  }) async {
    try {
      AppLogger.info('Updating product: $id');

      final data = <String, dynamic>{};
      if (title != null) data['title'] = title;
      if (price != null) data['price'] = price;
      if (description != null) data['description'] = description;
      if (categoryId != null) data['categoryId'] = categoryId;
      if (images != null) data['images'] = images;

      final response = await _dioClient.put(
        ApiConstants.productById(id),
        data: data,
      );

      final product = ProductModel.fromJson(response.data);
      AppLogger.info('Updated product: ${product.title}');
      return product;
    } catch (e, stackTrace) {
      AppLogger.error('Failed to update product', e, stackTrace);
      rethrow;
    }
  }

  /// Delete a product (Admin only)
  Future<bool> deleteProduct(int id) async {
    try {
      AppLogger.info('Deleting product: $id');

      await _dioClient.delete(ApiConstants.productById(id));

      AppLogger.info('Deleted product: $id');
      return true;
    } catch (e, stackTrace) {
      AppLogger.error('Failed to delete product', e, stackTrace);
      rethrow;
    }
  }

  /// Upload file/image
  Future<String> uploadFile(File file) async {
    try {
      AppLogger.info('Uploading file: ${file.path}');

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
      });

      final response = await _dioClient.post(
        ApiConstants.uploadFile,
        data: formData,
      );

      final imageUrl = response.data['location'] as String;
      AppLogger.info('File uploaded: $imageUrl');
      return imageUrl;
    } catch (e, stackTrace) {
      AppLogger.error('Failed to upload file', e, stackTrace);
      rethrow;
    }
  }
}
