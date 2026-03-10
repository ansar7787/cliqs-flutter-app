import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GlassTile extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final double opacity;

  const GlassTile({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.opacity = 0.05,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(24.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: opacity > 0.1 ? opacity : 0.45),
                Colors.white.withValues(
                  alpha: opacity > 0.1 ? opacity * 0.6 : 0.25,
                ),
              ],
            ),
            borderRadius: borderRadius ?? BorderRadius.circular(24.r),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.7),
              width: 2.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 60,
                spreadRadius: -10,
                offset: const Offset(0, 25),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
