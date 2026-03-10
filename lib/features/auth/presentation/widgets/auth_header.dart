import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final double? fontSize;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        SizedBox(height: 80.h),
        SizedBox(
          height: 80.h,
          child: Center(
            child: Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: fontSize ?? 56.sp,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF059669),
                letterSpacing: -2,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Text(
          subtitle,
          style: GoogleFonts.outfit(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white54 : const Color(0xFF6B7280),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 40.h),
      ],
    );
  }
}
