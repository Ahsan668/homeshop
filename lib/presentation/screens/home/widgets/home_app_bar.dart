import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:homeshop/core/router/route_names.dart';
import 'package:homeshop/core/theme/app_colors.dart';

/// Home App Bar - Custom app bar for home screen
///
/// Features:
/// - Gradient background
/// - Search button
/// - Notification icon
/// - Clean design
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary,
      elevation: 0,
      title: const Text(
        'HomeShop',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        // Search button
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: () {
            // Navigate to search screen
            context.push(RouteNames.search);
          },
        ),
        // Notifications button
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.white),
          onPressed: () {
            // TODO: Show notifications
          },
        ),
      ],
    );
  }
}
