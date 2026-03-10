import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AuraBackground extends StatelessWidget {
  final List<Widget>? additionalBlobs;

  const AuraBackground({super.key, this.additionalBlobs});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: [
          // Top Right Blob (Mint)
          Positioned(
            top: -150.h,
            right: -150.w,
            child:
                Container(
                      width: 500.w,
                      height: 500.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFFD1FAE5).withValues(alpha: 0.6),
                            const Color(0xFFD1FAE5).withValues(alpha: 0),
                          ],
                        ),
                      ),
                    )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .move(
                      duration: 25.seconds,
                      begin: Offset.zero,
                      end: const Offset(-80, 60),
                    )
                    .scale(
                      duration: 20.seconds,
                      begin: const Offset(1, 1),
                      end: const Offset(1.3, 1.3),
                    ),
          ),
          // Bottom Left Blob (Azure)
          Positioned(
            bottom: -200.h,
            left: -200.w,
            child:
                Container(
                      width: 600.w,
                      height: 600.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFFDBEAFE).withValues(alpha: 0.6),
                            const Color(0xFFDBEAFE).withValues(alpha: 0),
                          ],
                        ),
                      ),
                    )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .move(
                      duration: 30.seconds,
                      begin: Offset.zero,
                      end: const Offset(100, -50),
                    )
                    .scale(
                      duration: 25.seconds,
                      begin: const Offset(1, 1),
                      end: const Offset(1.2, 1.4),
                    ),
          ),
          // Additional Center Soft Glow (Optional)
          if (additionalBlobs != null) ...additionalBlobs!,
        ],
      ),
    );
  }
}
