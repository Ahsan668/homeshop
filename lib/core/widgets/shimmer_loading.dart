import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:homeshop/core/theme/app_colors.dart';

/// Shimmer loading widget for skeleton screens
class ShimmerLoading extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final BoxShape shape;

  const ShimmerLoading({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 12,
    this.shape = BoxShape.rectangle,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.greyLight,
      highlightColor: Colors.white,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.greyLight,
          borderRadius: shape == BoxShape.rectangle
              ? BorderRadius.circular(borderRadius)
              : null,
          shape: shape,
        ),
      ),
    );
  }
}

/// Product card shimmer loader
class ProductCardShimmer extends StatelessWidget {
  const ProductCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerLoading(
            width: double.infinity,
            height: 180,
            borderRadius: 16,
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ShimmerLoading(
                  width: 120,
                  height: 16,
                  borderRadius: 4,
                ),
                const SizedBox(height: 8),
                const ShimmerLoading(
                  width: 80,
                  height: 14,
                  borderRadius: 4,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const ShimmerLoading(
                      width: 60,
                      height: 20,
                      borderRadius: 4,
                    ),
                    ShimmerLoading(
                      width: 36,
                      height: 36,
                      borderRadius: 8,
                      shape: BoxShape.circle,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// List item shimmer loader
class ListItemShimmer extends StatelessWidget {
  const ListItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const ShimmerLoading(
            width: 80,
            height: 80,
            borderRadius: 12,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ShimmerLoading(
                  width: double.infinity,
                  height: 16,
                  borderRadius: 4,
                ),
                const SizedBox(height: 8),
                const ShimmerLoading(
                  width: 120,
                  height: 14,
                  borderRadius: 4,
                ),
                const SizedBox(height: 8),
                const ShimmerLoading(
                  width: 80,
                  height: 18,
                  borderRadius: 4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
