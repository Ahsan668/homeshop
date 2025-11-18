import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homeshop/core/di/injection.dart';
import 'package:homeshop/presentation/blocs/cart/cart_cubit.dart';
import 'package:homeshop/presentation/blocs/product/product_cubit.dart';
import 'package:homeshop/presentation/screens/home/widgets/home_view.dart';

/// Home Screen - Main entry point
///
/// Follows MVVM pattern:
/// - Screen provides BLoC providers
/// - View contains UI logic
/// - BLoCs manage state
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Product Cubit - Manages product list state
        BlocProvider(
          create: (_) => getIt<ProductCubit>()..loadProducts(),
        ),
        // Cart Cubit - Manages cart state globally
        BlocProvider(
          create: (_) => getIt<CartCubit>()..loadCart(),
        ),
      ],
      child: const HomeView(),
    );
  }
}
