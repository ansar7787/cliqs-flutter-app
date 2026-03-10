import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeGlassSlab extends StatelessWidget {
  final int totalTasks;
  final int completedTasks;

  const WelcomeGlassSlab({
    super.key,
    required this.totalTasks,
    required this.completedTasks,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = totalTasks == 0 ? 0.0 : completedTasks / totalTasks;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Container(
      constraints: BoxConstraints(
        minHeight: (isLandscape ? 120.h : 180.h).clamp(100, 250),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10B981).withValues(alpha: 0.12),
            blurRadius: 50,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Atmospheric Glow behind the card
          Positioned(
            bottom: -40,
            right: 40,
            child:
                Container(
                      width: 160.w,
                      height: 120.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF10B981,
                            ).withValues(alpha: 0.35),
                            blurRadius: 70,
                            spreadRadius: 25,
                          ),
                        ],
                      ),
                    )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .scale(
                      duration: 4.seconds,
                      begin: const Offset(1, 1),
                      end: const Offset(1.3, 1.2),
                    )
                    .move(
                      duration: 4.seconds,
                      begin: Offset.zero,
                      end: const Offset(-20, -10),
                    ),
          ),
          Positioned(
            top: -30,
            left: 50,
            child:
                Container(
                      width: 100.w,
                      height: 80.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF34D399,
                            ).withValues(alpha: 0.2),
                            blurRadius: 60,
                            spreadRadius: 15,
                          ),
                        ],
                      ),
                    )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .scale(
                      duration: 5.seconds,
                      begin: const Offset(1, 1),
                      end: const Offset(1.2, 1.1),
                    ),
          ),
          // The Glass Slab
          ClipRRect(
            borderRadius: BorderRadius.circular(32.r),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 28.w,
                  vertical: isLandscape ? 12.h : 28.h,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(32.r),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.6),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              totalTasks == 0
                                  ? "Let's begin"
                                  : totalTasks == completedTasks
                                  ? "All done!"
                                  : "Stay focused",
                              style: GoogleFonts.outfit(
                                color: const Color(0xFF1F2937),
                                fontWeight: FontWeight.w900,
                                fontSize: 34.sp,
                                letterSpacing: -1.2,
                              ),
                            ),
                          ),
                          SizedBox(height: isLandscape ? 2.h : 6.h),
                          Text(
                            totalTasks == 0
                                ? "Add a task to see progress"
                                : "$completedTasks of $totalTasks tasks completed",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(
                              color: const Color(0xFF6B7280),
                              fontWeight: FontWeight.w600,
                              fontSize: 16.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20.w),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: (isLandscape ? 60.w : 85.w).clamp(45, 95),
                          width: (isLandscape ? 60.w : 85.w).clamp(45, 95),
                          child: CircularProgressIndicator(
                            value: percentage,
                            strokeWidth: 10,
                            backgroundColor: const Color(0xFFF3F4F6),
                            color: const Color(0xFF10B981),
                            strokeCap: StrokeCap.round,
                          ),
                        ),
                        Text(
                          '${(percentage * 100).toInt()}%',
                          style: GoogleFonts.outfit(
                            color: const Color(0xFF1F2937),
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms).scale(begin: const Offset(0.9, 0.9));
  }
}
