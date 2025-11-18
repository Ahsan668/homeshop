import 'package:flutter/material.dart';
import 'package:homeshop/core/theme/app_colors.dart';

/// Curved AppBar with gradient background
class CurvedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final Gradient? gradient;
  final double height;
  final bool centerTitle;

  const CurvedAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.gradient,
    this.height = 120,
    this.centerTitle = true,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: gradient ?? AppColors.primaryGradient,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipPath(
        clipper: CurvedAppBarClipper(),
        child: Container(
          decoration: BoxDecoration(
            gradient: gradient ?? AppColors.primaryGradient,
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  if (leading != null)
                    leading!
                  else
                    const SizedBox(width: 40),
                  if (centerTitle) const Spacer(),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  if (centerTitle) const Spacer(),
                  if (!centerTitle) const Spacer(),
                  if (actions != null) ...actions!,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom clipper for curved app bar
class CurvedAppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 30,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

/// Simple curved container for backgrounds
class CurvedContainer extends StatelessWidget {
  final Widget child;
  final Gradient? gradient;
  final Color? color;
  final double height;

  const CurvedContainer({
    super.key,
    required this.child,
    this.gradient,
    this.color,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CurvedContainerClipper(),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          gradient: gradient,
          color: color,
        ),
        child: child,
      ),
    );
  }
}

/// Custom clipper for curved container
class CurvedContainerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 40,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
