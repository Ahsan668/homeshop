import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homeshop/core/utils/logger.dart';
import 'package:homeshop/data/models/product_model.dart';
import 'package:homeshop/domain/repositories/cart_repository.dart';
import 'package:homeshop/presentation/blocs/cart/cart_state.dart';

/// Cart Cubit
class CartCubit extends Cubit<CartState> {
  final CartRepository _repository;

  CartCubit(this._repository) : super(const CartInitial());

  /// Load cart items
  Future<void> loadCart() async {
    try {
      emit(const CartLoading());

      final itemsResult = await _repository.getCartItems();
      final totalResult = await _repository.getCartTotal();
      final countResult = await _repository.getCartItemCount();

      itemsResult.fold(
        (error) => emit(CartError(error)),
        (items) {
          totalResult.fold(
            (error) => emit(CartError(error)),
            (total) {
              countResult.fold(
                (error) => emit(CartError(error)),
                (count) {
                  emit(CartLoaded(
                    items: items,
                    total: total,
                    itemCount: count,
                  ));
                },
              );
            },
          );
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error('Error loading cart', e, stackTrace);
      emit(CartError(e.toString()));
    }
  }

  /// Add item to cart
  Future<void> addToCart(ProductModel product, {int quantity = 1}) async {
    try {
      final currentState = state;

      // Show loading or keep current state
      if (currentState is! CartLoaded) {
        emit(const CartLoading());
      }

      final result = await _repository.addToCart(product, quantity: quantity);

      result.fold(
        (error) {
          AppLogger.error('Failed to add to cart: $error');
          emit(CartError(error));
          // Reload cart to restore state
          loadCart();
        },
        (_) {
          AppLogger.info('Added to cart: ${product.title}');
          // Reload cart to update UI
          loadCart();
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error('Error adding to cart', e, stackTrace);
      emit(CartError(e.toString()));
      loadCart();
    }
  }

  /// Remove item from cart
  Future<void> removeFromCart(int productId, String productName) async {
    try {
      final result = await _repository.removeFromCart(productId);

      result.fold(
        (error) {
          AppLogger.error('Failed to remove from cart: $error');
          emit(CartError(error));
          loadCart();
        },
        (_) {
          AppLogger.info('Removed from cart: productId=$productId');
          emit(CartItemRemoved(productName));
          // Reload cart to update UI
          loadCart();
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error('Error removing from cart', e, stackTrace);
      emit(CartError(e.toString()));
      loadCart();
    }
  }

  /// Update item quantity
  Future<void> updateQuantity(int productId, int quantity) async {
    try {
      final result = await _repository.updateQuantity(productId, quantity);

      result.fold(
        (error) {
          AppLogger.error('Failed to update quantity: $error');
          emit(CartError(error));
          loadCart();
        },
        (_) {
          AppLogger.info('Updated quantity: productId=$productId, quantity=$quantity');
          // Reload cart to update UI
          loadCart();
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error('Error updating quantity', e, stackTrace);
      emit(CartError(e.toString()));
      loadCart();
    }
  }

  /// Clear cart
  Future<void> clearCart() async {
    try {
      final result = await _repository.clearCart();

      result.fold(
        (error) {
          AppLogger.error('Failed to clear cart: $error');
          emit(CartError(error));
        },
        (_) {
          AppLogger.info('Cart cleared');
          emit(const CartCleared());
          // Reload empty cart
          loadCart();
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error('Error clearing cart', e, stackTrace);
      emit(CartError(e.toString()));
    }
  }

  /// Increment item quantity
  Future<void> incrementQuantity(int productId) async {
    final currentState = state;
    if (currentState is CartLoaded) {
      final item = currentState.items.firstWhere(
        (item) => item.product.id == productId,
      );
      await updateQuantity(productId, item.quantity + 1);
    }
  }

  /// Decrement item quantity
  Future<void> decrementQuantity(int productId, String productName) async {
    final currentState = state;
    if (currentState is CartLoaded) {
      final item = currentState.items.firstWhere(
        (item) => item.product.id == productId,
      );

      if (item.quantity > 1) {
        await updateQuantity(productId, item.quantity - 1);
      } else {
        await removeFromCart(productId, productName);
      }
    }
  }
}
