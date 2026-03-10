import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class TaskEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSliver;

  const TaskEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.isSliver = true,
  });

  @override
  Widget build(BuildContext context) {
    final content = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24.r),
            decoration: const BoxDecoration(
              color: Color(0xFFF9FAFB),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 48.w, color: const Color(0xFFE5E7EB)),
          ),
          SizedBox(height: 24.h),
          Text(
            title,
            style: GoogleFonts.outfit(
              color: const Color(0xFF111827),
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            subtitle,
            style: GoogleFonts.outfit(
              color: const Color(0xFF9CA3AF),
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    ).animate().fadeIn().scale(begin: const Offset(0.9, 0.9));

    if (isSliver) {
      return SliverFillRemaining(hasScrollBody: false, child: content);
    }
    return content;
  }
}
