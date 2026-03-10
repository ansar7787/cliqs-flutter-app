import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) context.go('/');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Subtle Top Decorative Element
          Positioned(
            top: -50.h,
            right: -50.w,
            child: Container(
              width: 200.w,
              height: 200.w,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
            ).animate().scale(duration: 2.seconds, curve: Curves.easeInOut),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLogo(),
                SizedBox(height: 32.h),
                _buildTextContent(),
              ],
            ),
          ),

          // Version/Branding Footer
          Positioned(
            bottom: 40.h,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Propel Your Life',
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 3,
                ),
              ).animate().fadeIn(delay: 1.seconds),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                blurRadius: 40,
                spreadRadius: 10,
              ),
            ],
            border: Border.all(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              width: 1.5,
            ),
          ),
          child: Icon(
            Icons.task_alt_rounded,
            size: 72.w,
            color: Theme.of(context).primaryColor,
          ),
        )
        .animate()
        .scale(duration: 800.ms, curve: Curves.elasticOut)
        .shimmer(
          duration: 2.seconds,
          color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
        );
  }

  Widget _buildTextContent() {
    return Column(
      children: [
        Text(
              'CLIQS',
              style: TextStyle(
                color: AppTheme.lightText,
                fontSize: 36.sp,
                fontWeight: FontWeight.w900,
                letterSpacing: -1,
              ),
            )
            .animate()
            .fadeIn(delay: 400.ms)
            .slideY(begin: 0.2, curve: Curves.easeOutCubic),
        SizedBox(height: 4.h),
        Container(
          height: 3.h,
          width: 40.w,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
        ).animate().scaleX(delay: 600.ms, duration: 800.ms),
      ],
    );
  }
}
