import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class NetworkErrorPage extends StatelessWidget {
  final VoidCallback onRetry;

  const NetworkErrorPage({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Aura Background (Soft Red for error)
          Positioned.fill(
            child: Stack(
              children: [
                Positioned(
                  top: -100.h,
                  right: -50.w,
                  child: Container(
                    width: 300.w,
                    height: 300.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.red.withValues(alpha: 0.1),
                          Colors.red.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
                        duration: 10.seconds,
                        begin: const Offset(1, 1),
                        end: const Offset(1.2, 1.2),
                      ),
                ),
              ],
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipOval(
                    child: Container(
                      padding: EdgeInsets.all(32.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.8),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withValues(
                              alpha: 0.1,
                            ),
                            blurRadius: 40,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.wifi_off_rounded,
                        size: 64.w,
                        color: Colors.red.shade400,
                      ),
                    ).animate(onPlay: (c) => c.repeat(reverse: true)).shimmer(
                          duration: 3.seconds,
                          color: Colors.white,
                        ),
                  ).animate(onPlay: (c) => c.repeat(reverse: true)).moveY(
                        begin: -10,
                        end: 10,
                        duration: 4.seconds,
                        curve: Curves.easeInOut,
                      ),
                  SizedBox(height: 48.h),
                  Text(
                    'Connection Lost',
                    style: GoogleFonts.outfit(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF111827),
                      letterSpacing: -1,
                    ),
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
                  SizedBox(height: 12.h),
                  Text(
                    'You are offline. Please check your internet connection and try again.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF6B7280),
                      height: 1.4,
                    ),
                  ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
                  SizedBox(height: 48.h),
                  ElevatedButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      onRetry();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF111827),
                      foregroundColor: Colors.white,
                      minimumSize: Size(200.w, 56.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Try Again',
                      style: GoogleFonts.outfit(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 400.ms)
                      .scale(begin: const Offset(0.9, 0.9)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
