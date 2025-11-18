import 'package:dartz/dartz.dart';
import 'package:homeshop/data/models/cart_item_model.dart';
import 'package:homeshop/data/models/product_model.dart';

/// Cart repository interface
abstract class CartRepository {
  /// Get all cart items
  Future<Either<String, List<CartItemModel>>> getCartItems();

  /// Add item to cart
  Future<Either<String, void>> addToCart(ProductModel product, {int quantity = 1});

  /// Remove item from cart
  Future<Either<String, void>> removeFromCart(int productId);

  /// Update item quantity
  Future<Either<String, void>> updateQuantity(int productId, int quantity);

  /// Clear cart
  Future<Either<String, void>> clearCart();

  /// Get cart total price
  Future<Either<String, double>> getCartTotal();

  /// Get cart item count
  Future<Either<String, int>> getCartItemCount();
}
