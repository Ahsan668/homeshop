import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:homeshop/core/utils/logger.dart';
import 'package:homeshop/data/models/category_model.dart';
import 'package:homeshop/data/models/product_model.dart';
import 'package:homeshop/data/services/api/product_api_service.dart';
import 'package:homeshop/domain/repositories/product_repository.dart';

/// Product repository implementation
class ProductRepositoryImpl implements ProductRepository {
  final ProductApiService _apiService;

  ProductRepositoryImpl(this._apiService);

  @override
  Future<Either<String, List<ProductModel>>> getProducts({
    int offset = 0,
    int limit = 10,
  }) async {
    try {
      final products = await _apiService.getProducts(
        offset: offset,
        limit: limit,
      );
      return Right(products);
    } on DioException catch (e) {
      AppLogger.error('DioException in getProducts', e);
      return Left(_handleDioError(e));
    } catch (e) {
      AppLogger.error('Exception in getProducts', e);
      return const Left('An unexpected error occurred');
    }
  }

  @override
  Future<Either<String, ProductModel>> getProductById(int id) async {
    try {
      final product = await _apiService.getProductById(id);
      return Right(product);
    } on DioException catch (e) {
      AppLogger.error('DioException in getProductById', e);
      return Left(_handleDioError(e));
    } catch (e) {
      AppLogger.error('Exception in getProductById', e);
      return const Left('An unexpected error occurred');
    }
  }

  @override
  Future<Either<String, List<ProductModel>>> getProductsByCategory({
    required int categoryId,
    int offset = 0,
    int limit = 10,
  }) async {
    try {
      final products = await _apiService.getProductsByCategory(
        categoryId: categoryId,
        offset: offset,
        limit: limit,
      );
      return Right(products);
    } on DioException catch (e) {
      AppLogger.error('DioException in getProductsByCategory', e);
      return Left(_handleDioError(e));
    } catch (e) {
      AppLogger.error('Exception in getProductsByCategory', e);
      return const Left('An unexpected error occurred');
    }
  }

  @override
  Future<Either<String, List<ProductModel>>> searchProducts({
    required String query,
    int offset = 0,
    int limit = 10,
  }) async {
    try {
      final products = await _apiService.searchProducts(
        query: query,
        offset: offset,
        limit: limit,
      );
      return Right(products);
    } on DioException catch (e) {
      AppLogger.error('DioException in searchProducts', e);
      return Left(_handleDioError(e));
    } catch (e) {
      AppLogger.error('Exception in searchProducts', e);
      return const Left('An unexpected error occurred');
    }
  }

  @override
  Future<Either<String, List<CategoryModel>>> getCategories() async {
    try {
      final categories = await _apiService.getCategories();
      return Right(categories);
    } on DioException catch (e) {
      AppLogger.error('DioException in getCategories', e);
      return Left(_handleDioError(e));
    } catch (e) {
      AppLogger.error('Exception in getCategories', e);
      return const Left('An unexpected error occurred');
    }
  }

  @override
  Future<Either<String, CategoryModel>> getCategoryById(int id) async {
    try {
      final category = await _apiService.getCategoryById(id);
      return Right(category);
    } on DioException catch (e) {
      AppLogger.error('DioException in getCategoryById', e);
      return Left(_handleDioError(e));
    } catch (e) {
      AppLogger.error('Exception in getCategoryById', e);
      return const Left('An unexpected error occurred');
    }
  }

  @override
  Future<Either<String, ProductModel>> createProduct({
    required String title,
    required double price,
    required String description,
    required int categoryId,
    required List<String> images,
  }) async {
    try {
      final product = await _apiService.createProduct(
        title: title,
        price: price,
        description: description,
        categoryId: categoryId,
        images: images,
      );
      return Right(product);
    } on DioException catch (e) {
      AppLogger.error('DioException in createProduct', e);
      return Left(_handleDioError(e));
    } catch (e) {
      AppLogger.error('Exception in createProduct', e);
      return const Left('An unexpected error occurred');
    }
  }

  @override
  Future<Either<String, ProductModel>> updateProduct({
    required int id,
    String? title,
    double? price,
    String? description,
    int? categoryId,
    List<String>? images,
  }) async {
    try {
      final product = await _apiService.updateProduct(
        id: id,
        title: title,
        price: price,
        description: description,
        categoryId: categoryId,
        images: images,
      );
      return Right(product);
    } on DioException catch (e) {
      AppLogger.error('DioException in updateProduct', e);
      return Left(_handleDioError(e));
    } catch (e) {
      AppLogger.error('Exception in updateProduct', e);
      return const Left('An unexpected error occurred');
    }
  }

  @override
  Future<Either<String, bool>> deleteProduct(int id) async {
    try {
      final success = await _apiService.deleteProduct(id);
      return Right(success);
    } on DioException catch (e) {
      AppLogger.error('DioException in deleteProduct', e);
      return Left(_handleDioError(e));
    } catch (e) {
      AppLogger.error('Exception in deleteProduct', e);
      return const Left('An unexpected error occurred');
    }
  }

  @override
  Future<Either<String, String>> uploadFile(File file) async {
    try {
      final imageUrl = await _apiService.uploadFile(file);
      return Right(imageUrl);
    } on DioException catch (e) {
      AppLogger.error('DioException in uploadFile', e);
      return Left(_handleDioError(e));
    } catch (e) {
      AppLogger.error('Exception in uploadFile', e);
      return const Left('An unexpected error occurred');
    }
  }

  /// Handle Dio errors and return user-friendly messages
  String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please try again.';
      case DioExceptionType.badResponse:
        return 'Server error: ${error.response?.statusCode}';
      case DioExceptionType.cancel:
        return 'Request cancelled';
      case DioExceptionType.connectionError:
        return 'No internet connection';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}
