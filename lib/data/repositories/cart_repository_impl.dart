import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import 'package:homeshop/core/constants/hive_constants.dart';
import 'package:homeshop/core/utils/logger.dart';
import 'package:homeshop/data/models/cart_item_model.dart';
import 'package:homeshop/data/models/product_model.dart';
import 'package:homeshop/domain/repositories/cart_repository.dart';

/// Cart repository implementation using Hive
class CartRepositoryImpl implements CartRepository {
  Box<CartItemModel> get _cartBox => Hive.box<CartItemModel>(HiveConstants.cartBox);

  @override
  Future<Either<String, List<CartItemModel>>> getCartItems() async {
    try {
      final items = _cartBox.values.toList();
      AppLogger.info('Retrieved ${items.length} items from cart');
      return Right(items);
    } catch (e, stackTrace) {
      AppLogger.error('Failed to get cart items', e, stackTrace);
      return const Left('Failed to load cart items');
    }
  }

  @override
  Future<Either<String, void>> addToCart(
    ProductModel product, {
    int quantity = 1,
  }) async {
    try {
      final existingItemKey = _findCartItemKey(product.id);

      if (existingItemKey != null) {
        // Update existing item quantity
        final existingItem = _cartBox.get(existingItemKey)!;
        final updatedItem = existingItem.copyWith(
          quantity: existingItem.quantity + quantity,
        );
        await _cartBox.put(existingItemKey, updatedItem);
        AppLogger.info('Updated cart item: ${product.title}, new quantity: ${updatedItem.quantity}');
      } else {
        // Add new item
        final cartItem = CartItemModel(
          product: product,
          quantity: quantity,
        );
        await _cartBox.add(cartItem);
        AppLogger.info('Added new item to cart: ${product.title}');
      }

      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.error('Failed to add to cart', e, stackTrace);
      return const Left('Failed to add item to cart');
    }
  }

  @override
  Future<Either<String, void>> removeFromCart(int productId) async {
    try {
      final key = _findCartItemKey(productId);

      if (key != null) {
        await _cartBox.delete(key);
        AppLogger.info('Removed item from cart: productId=$productId');
        return const Right(null);
      } else {
        return const Left('Item not found in cart');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Failed to remove from cart', e, stackTrace);
      return const Left('Failed to remove item from cart');
    }
  }

  @override
  Future<Either<String, void>> updateQuantity(int productId, int quantity) async {
    try {
      if (quantity <= 0) {
        return removeFromCart(productId);
      }

      final key = _findCartItemKey(productId);

      if (key != null) {
        final existingItem = _cartBox.get(key)!;
        final updatedItem = existingItem.copyWith(quantity: quantity);
        await _cartBox.put(key, updatedItem);
        AppLogger.info('Updated item quantity: productId=$productId, quantity=$quantity');
        return const Right(null);
      } else {
        return const Left('Item not found in cart');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Failed to update quantity', e, stackTrace);
      return const Left('Failed to update item quantity');
    }
  }

  @override
  Future<Either<String, void>> clearCart() async {
    try {
      await _cartBox.clear();
      AppLogger.info('Cart cleared');
      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.error('Failed to clear cart', e, stackTrace);
      return const Left('Failed to clear cart');
    }
  }

  @override
  Future<Either<String, double>> getCartTotal() async {
    try {
      final items = _cartBox.values.toList();
      final total = items.fold<double>(
        0.0,
        (sum, item) => sum + item.totalPrice,
      );
      AppLogger.info('Cart total: \$$total');
      return Right(total);
    } catch (e, stackTrace) {
      AppLogger.error('Failed to calculate cart total', e, stackTrace);
      return const Left('Failed to calculate cart total');
    }
  }

  @override
  Future<Either<String, int>> getCartItemCount() async {
    try {
      final items = _cartBox.values.toList();
      final count = items.fold<int>(
        0,
        (sum, item) => sum + item.quantity,
      );
      AppLogger.info('Cart item count: $count');
      return Right(count);
    } catch (e, stackTrace) {
      AppLogger.error('Failed to get cart item count', e, stackTrace);
      return const Left('Failed to get cart item count');
    }
  }

  /// Find cart item key by product ID
  dynamic _findCartItemKey(int productId) {
    for (var key in _cartBox.keys) {
      final item = _cartBox.get(key);
      if (item?.product.id == productId) {
        return key;
      }
    }
    return null;
  }
}
