import 'package:flutter/material.dart';
import 'package:homeshop/core/theme/app_colors.dart';
import 'package:homeshop/core/widgets/gradient_button.dart';

/// Empty state widget with optional Lottie animation
class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final IconData? icon;
  final String? lottieAsset;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final double iconSize;

  const EmptyStateWidget({
    super.key,
    required this.title,
    required this.message,
    this.icon,
    this.lottieAsset,
    this.buttonText,
    this.onButtonPressed,
    this.iconSize = 120,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon or Lottie animation
            if (lottieAsset != null)
              // TODO: Add Lottie animation when assets are ready
              // Lottie.asset(
              //   lottieAsset!,
              //   width: iconSize * 2,
              //   height: iconSize * 2,
              // )
              Icon(
                icon ?? Icons.inbox_outlined,
                size: iconSize,
                color: AppColors.grey,
              )
            else
              Container(
                width: iconSize,
                height: iconSize,
                decoration: BoxDecoration(
                  color: AppColors.primaryExtraLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon ?? Icons.inbox_outlined,
                  size: iconSize * 0.5,
                  color: AppColors.primary,
                ),
              ),
            const SizedBox(height: 24),
            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            // Message
            Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            // Button
            if (buttonText != null && onButtonPressed != null) ...[
              const SizedBox(height: 32),
              GradientButton(
                text: buttonText!,
                onPressed: onButtonPressed!,
                width: 200,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Loading state widget
class LoadingStateWidget extends StatelessWidget {
  final String? message;

  const LoadingStateWidget({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Error state widget
class ErrorStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;

  const ErrorStateWidget({
    super.key,
    this.title = 'Oops!',
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                size: 60,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 32),
              GradientButton(
                text: 'Try Again',
                onPressed: onRetry!,
                width: 200,
                icon: Icons.refresh,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
