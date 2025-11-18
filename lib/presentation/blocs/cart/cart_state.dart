import 'package:equatable/equatable.dart';
import 'package:homeshop/data/models/cart_item_model.dart';

/// Cart states
abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class CartInitial extends CartState {
  const CartInitial();
}

/// Loading state
class CartLoading extends CartState {
  const CartLoading();
}

/// Loaded state
class CartLoaded extends CartState {
  final List<CartItemModel> items;
  final double total;
  final int itemCount;

  const CartLoaded({
    required this.items,
    required this.total,
    required this.itemCount,
  });

  @override
  List<Object?> get props => [items, total, itemCount];

  CartLoaded copyWith({
    List<CartItemModel>? items,
    double? total,
    int? itemCount,
  }) {
    return CartLoaded(
      items: items ?? this.items,
      total: total ?? this.total,
      itemCount: itemCount ?? this.itemCount,
    );
  }
}

/// Error state
class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Item added state
class CartItemAdded extends CartState {
  final String productName;

  const CartItemAdded(this.productName);

  @override
  List<Object?> get props => [productName];
}

/// Item removed state
class CartItemRemoved extends CartState {
  final String productName;

  const CartItemRemoved(this.productName);

  @override
  List<Object?> get props => [productName];
}

/// Cart cleared state
class CartCleared extends CartState {
  const CartCleared();
}
